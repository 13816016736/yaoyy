package com.ms.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ms.dao.*;
import com.ms.dao.enums.*;
import com.ms.dao.model.*;
import com.ms.dao.vo.*;
import com.ms.service.*;
import com.ms.service.enums.MessageEnum;
import com.ms.service.enums.RedisEnum;
import com.ms.service.observer.MsgConsumeEvent;
import com.ms.service.observer.MsgProducerEvent;
import com.ms.tools.exception.ControllerException;
import com.ms.tools.utils.SeqNoUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Service
public class PickServiceImpl  extends AbsCommonService<Pick> implements PickService{

	@Autowired
	private PickDao pickDao;


	@Autowired
	private PickCommodityService pickCommodityService;


	@Autowired
	private UserDao userDao;

	@Autowired
	private UserDetailDao userDetailDao;


	@Autowired
	private PickTrackingDao pickTrackingDao;

	@Autowired
	private CommodityService commodityService;

	private CodeDao codeDao;

	@Autowired
	private  ApplicationContext applicationContext;

	@Autowired
	private MemberService memberService;

	@Autowired
	private PickTrackingService  pickTrackingService;

	@Autowired
	private LogisticalService logisticalService;

	@Autowired
	private ShippingAddressService shippingAddressService;

	@Autowired
	private ShippingAddressHistoryService shippingAddressHistoryService;

	@Autowired
	private OrderInvoiceService orderInvoiceService;

	@Autowired
	private PaymentService paymentService;

	@Autowired
	private PayRecordService payRecordService;

	@Autowired
	private AccountBillService accountBillService;




	@Override
	public PageInfo<PickVo> findByParams(PickVo pickVo,Integer pageNum,Integer pageSize) {
		pageNum = pageNum==null?1:pageNum;
		pageSize = pageSize==null?10:pageSize;
        PageHelper.startPage(pageNum, pageSize);
    	List<PickVo>  list = pickDao.findByParams(pickVo);
		list.forEach(p->{
			List<PickCommodityVo> pickCommodityVos=pickCommodityService.findByPickId(p.getId());
			float total=0;

			for(PickCommodityVo vo :pickCommodityVos){
				total+=vo.getTotal();
			}
			p.setTotal(total);

			p.setPickCommodityVoList(pickCommodityVos);
		});
        PageInfo page = new PageInfo(list);
        return page;
	}

	@Override
	public PickVo findVoById(Integer id) {
		PickVo pickVo=pickDao.findVoById(id);
		List<PickCommodityVo> pickCommodityVos=pickCommodityService.findByPickId(id);
		float total=0;

		for(PickCommodityVo vo :pickCommodityVos){
			total+=vo.getTotal();
		}
		pickVo.setTotal(total);

		pickVo.setPickCommodityVoList(pickCommodityVos);

		// 发票信息
		pickVo.setInvoice(orderInvoiceService.findByOrderId(pickVo.getId()));
		return pickVo;
	}

	@Override
	@Transactional
	public void save(PickVo pickVo) {
		UserVo userVo=userDao.findByPhone(pickVo.getPhone());

		Integer nowLogin=pickVo.getUserId();//现在登录的userid
		//如果用户注册
		Date now=new Date();

		int useId;
		if (userVo==null){
			User user=new User();
			user.setPhone(pickVo.getPhone());
			user.setType(UserEnum.auto.getType());
			user.setSalt("");
			user.setPassword("");
			//user.setOpenid("");
			user.setUpdateTime(now);
			user.setCreateTime(now);
			userDao.create(user);

			useId=user.getId();
		}
		else{
			useId=userVo.getId();
		}
		UserDetail userDetail=userDetailDao.findByUserId(useId);
		if (userDetail==null){
			userDetail=new UserDetail();
			userDetail.setPhone(pickVo.getPhone());
			userDetail.setNickname(pickVo.getNickname());
			userDetail.setArea("");
			userDetail.setUserId(useId);
			userDetail.setName("");
			userDetail.setRemark("");
			userDetail.setType(0);
			userDetail.setUpdateTime(now);
			userDetail.setCreateTime(now);
			userDetailDao.create(userDetail);
		}
		else{
			userDetail.setPhone(pickVo.getPhone());
			userDetail.setNickname(pickVo.getNickname());
			userDetail.setUpdateTime(now);
			userDetailDao.update(userDetail);
		}




		Pick pick=new Pick();
		if(nowLogin==null){
			pick.setUserId(useId);
		}
		else{
			pick.setUserId(nowLogin);
		}
		pick.setNickname(pickVo.getNickname());
		pick.setPhone(pickVo.getPhone());
		pick.setStatus(PickEnum.PICK_NOTHANDLE.getValue());
		pick.setUpdateTime(now);
		pick.setCreateTime(now);
		pick.setCode("");
		pick.setAbandon(0);

		/**
		 * 设置code
		 */
		pick.setCode(SeqNoUtil.getOrderCode());
		pickDao.create(pick);

		pickVo.getPickCommodityVoList().forEach(c->{
			c.setPickId(pick.getId());
		});
		pickCommodityService.saveList(pickVo.getPickCommodityVoList());



		PickTracking pickTracking=new PickTracking();
		pickTracking.setName(pickVo.getNickname());
		pickTracking.setOpType(TrackingTypeEnum.TYPE_USER.getValue());
		if(nowLogin==null){
			pickTracking.setOperator(useId);
		}
		else{
			pickTracking.setOperator(nowLogin);
		}
		pickTracking.setExtra("");
		pickTracking.setCreateTime(now);
		pickTracking.setUpdateTime(now);
		pickTracking.setPickId(pick.getId());
		pickTracking.setRecordType(PickTrackingTypeEnum.PICK_APPLY.getValue());
		pickTrackingDao.create(pickTracking);

		/**
		 * 存消息
		 *
		 */
		String content=pick.getNickname()+"提交选货单";
		MsgProducerEvent msgProducerEvent =new MsgProducerEvent(pick.getUserId(),pick.getId(), MessageEnum.PICK,content);
		applicationContext.publishEvent(msgProducerEvent);



	}

	@Override
	@Transactional
	public void createOrder(PickVo pickVo) {

		PickVo oldPick=pickDao.findVoById(pickVo.getId());
		if(!PickEnum.PICK_PAY.getValue().equals(oldPick.getStatus())){
			//创建一条生成订单跟踪记录
			PickTracking pickTracking=new PickTracking();
			if(pickVo.getMemberId()!=null){
				Member member=memberService.findById(pickVo.getMemberId());
				pickTracking.setName(member.getName());
				pickTracking.setOpType(TrackingTypeEnum.TYPE_ADMIN.getValue());
				pickTracking.setOperator(member.getId());
			}
			else{
				PickVo pick=pickDao.findVoById(pickVo.getId());
				pickTracking.setName(pick.getNickname());
				pickTracking.setOpType(TrackingTypeEnum.TYPE_USER.getValue());
				pickTracking.setOperator(pickVo.getUserId());
			}


			pickTracking.setExtra("");
			pickTracking.setCreateTime(new Date());
			pickTracking.setUpdateTime(new Date());
			pickTracking.setPickId(pickVo.getId());
			pickTracking.setRecordType(PickTrackingTypeEnum.PICK_ORDER.getValue());
			pickTrackingDao.create(pickTracking);

		}
		else{
			//创建一条修改结算详情的记录
			for(PickCommodity pickCommodity:pickVo.getPickCommodityVoList()){
				pickCommodityService.update(pickCommodity);
			}
			PickTracking pickTracking=new PickTracking();
			if(pickVo.getMemberId()!=null){
				Member member=memberService.findById(pickVo.getMemberId());
				pickTracking.setName(member.getName());
				pickTracking.setOpType(TrackingTypeEnum.TYPE_ADMIN.getValue());
				pickTracking.setOperator(member.getId());
			}
			else{
				PickVo pick=pickDao.findVoById(pickVo.getId());
				pickTracking.setName(pick.getNickname());
				pickTracking.setOpType(TrackingTypeEnum.TYPE_USER.getValue());
				pickTracking.setOperator(pickVo.getUserId());
			}



			pickTracking.setExtra("");
			pickTracking.setCreateTime(new Date());
			pickTracking.setUpdateTime(new Date());
			pickTracking.setPickId(pickVo.getId());
			pickTracking.setRecordType(PickTrackingTypeEnum.PICK_UPDATE.getValue());
			pickTrackingDao.create(pickTracking);

		}
		//全款或保证金
		if(pickVo.getSettleType()==SettleTypeEnum.SETTLE_ALL.getType()||pickVo.getSettleType()==SettleTypeEnum.SETTLE_DEPOSIT.getType()){
			pickVo.setStatus(PickEnum.PICK_PAY.getValue());
		}
		else{
			pickVo.setStatus(PickEnum.PICK_CONFIRM.getValue());
		}
		//设置有效期
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
		calendar.add(Calendar.DATE, 3);
		pickVo.setExpireDate(calendar.getTime());
		pickDao.update(pickVo);


	}

	@Override
	@Transactional
	public void changeOrderStatus(Integer id, Integer status) {
		Pick pick=new Pick();
		pick.setId(id);
		pick.setStatus(status);
		pick.setUpdateTime(new Date());
		pickDao.update(pick);

		//增加跟踪记录
		PickVo pickVo=pickDao.findVoById(id);
		PickTracking pickTracking=new PickTracking();
		pickTracking.setName(pickVo.getNickname());
		pickTracking.setOpType(TrackingTypeEnum.TYPE_USER.getValue());
		pickTracking.setOperator(pickVo.getUserId());



		pickTracking.setExtra("");
		pickTracking.setCreateTime(new Date());
		pickTracking.setUpdateTime(new Date());
		pickTracking.setPickId(pickVo.getId());
		if(status==PickEnum.PICK_CANCLE.getValue()){
			pickTracking.setRecordType(PickTrackingTypeEnum.PICK_CANCEL.getValue());
			pickTrackingDao.create(pickTracking);
		}else if(status==PickEnum.PICK_FINISH.getValue()){
			pickTracking.setRecordType(PickTrackingTypeEnum.PICK_RECEIPT.getValue());
			pickTrackingDao.create(pickTracking);
		}


	}
    @Override
	@Transactional
	public void updateCommodityNum(List<PickCommodity> pickCommodities) {
		for(PickCommodity pickCommodity:pickCommodities){
			pickCommodityService.update(pickCommodity);
		}
	}

	@Override
	@Transactional
	public void delivery(LogisticalVo logisticalVo,Member mem) {
		logisticalService.save(logisticalVo);

		Date now=new Date();
		Pick pick =new Pick();
		pick.setId(logisticalVo.getOrderId());
		pick.setStatus(PickEnum.PICK_DELIVERIED.getValue());
		pick.setDeliveryDate(logisticalVo.getShipDate());
		pick.setUpdateTime(now);
		pickDao.update(pick);

		PickTrackingVo pickTrackingVo=new PickTrackingVo();
		pickTrackingVo.setPickId(logisticalVo.getOrderId());
		pickTrackingVo.setOperator(mem.getId());
		pickTrackingVo.setOpType(TrackingTypeEnum.TYPE_ADMIN.getValue());
		pickTrackingVo.setName(mem.getName());
		pickTrackingVo.setRecordType(PickTrackingTypeEnum.PICK_ORDER_DELIVERIED.getValue());
		if(pickTrackingVo.getExtra()==null){
			pickTrackingVo.setExtra("");
		}
		pickTrackingVo.setCreateTime(now);
		pickTrackingVo.setUpdateTime(now);

		pickTrackingDao.create(pickTrackingVo);
	}

	@Override
	@Transactional
	public void handlePay(PaymentVo payment) {
		//更新payment
		payment.setCallbackTime(new Date());
		paymentService.update(payment);

		//创建支付记录
		PayRecordVo payRecordVo=new PayRecordVo();
		payRecordVo.setCodeType(payment.getType());
		//订单支付
		if(payment.getType()==0){
			PickVo pickVo=findVoById(payment.getOrderId());
			payRecordVo.setCode(pickVo.getCode());
			payRecordVo.setOrderId(payment.getOrderId());
		}else{
			AccountBillVo accountBillVo=accountBillService.findVoById(payment.getBillId());
			payRecordVo.setCode(accountBillVo.getCode());
			payRecordVo.setAccountBillId(payment.getBillId());
		}
		payRecordVo.setPaymentId(payment.getId());
		payRecordVo.setUserId(payment.getUserId());
		payRecordVo.setActualPayment(payment.getMoney());
		payRecordVo.setPayAccount(payment.getPayAppId());
		payRecordVo.setPaymentTime(payment.getCreateTime());
		payRecordVo.setStatus(payment.getStatus());
		payRecordVo.setPayType(payment.getPayType());
		payRecordVo.setCreateTime(new Date());

		payRecordService.save(payRecordVo);
		//如果支付成功更新订单状态并添加跟踪记录
		if(payment.getStatus()==1){
			//如果存在账期就为这个用户生成账单
			if(payment.getType()==0){//订单支付
				PickVo pick=findVoById(payment.getOrderId());
				if(pick.getSettleType()== SettleTypeEnum.SETTLE_DEPOSIT.getType()){
					AccountBillVo accountBillVo=new AccountBillVo();
					accountBillVo.setMemberId(pick.getMemberId());
					accountBillVo.setOrderId(pick.getId());
					accountBillVo.setUserId(pick.getUserId());
					accountBillVo.setBillTime(pick.getBillTime());
					accountBillVo.setAlreadyPayable(pick.getDeposit());
					accountBillVo.setAmountsPayable(pick.getAmountsPayable());
					accountBillService.saveAccountBill(accountBillVo);
				}
				PickTrackingVo pickTrackingVo=new PickTrackingVo();
				pickTrackingVo.setPickId(payment.getOrderId());

				pickTrackingVo.setOperator(pick.getUserId());
				pickTrackingVo.setName(pick.getNickname());
				pickTrackingVo.setOpType(TrackingTypeEnum.TYPE_USER.getValue());

				if(pick.getSettleType()== SettleTypeEnum.SETTLE_DEPOSIT.getType()){
					pickTrackingVo.setRecordType(PickTrackingTypeEnum.PICK_SELFPAY_DEPOSTI.getValue());
				}
				else{
					pickTrackingVo.setRecordType(PickTrackingTypeEnum.PICK_SELFPAY_ALL.getValue());
				}
				pickTrackingService.save(pickTrackingVo);
			}
			else{
				//账单支付需要更改账单状态
                AccountBillVo accountBillVo=accountBillService.findVoById(payment.getBillId());
				accountBillVo.setAlreadyPayable(accountBillVo.getAlreadyPayable()+payment.getMoney());
				accountBillVo.setStatus(1);
				accountBillService.update(accountBillVo);

				PickVo pick=findVoById(accountBillVo.getOrderId());
				PickTrackingVo pickTrackingVo=new PickTrackingVo();
				pickTrackingVo.setPickId(payment.getOrderId());
				pickTrackingVo.setOperator(pick.getUserId());
				pickTrackingVo.setName(pick.getNickname());
				pickTrackingVo.setOpType(TrackingTypeEnum.TYPE_USER.getValue());

				pickTrackingVo.setRecordType(PickTrackingTypeEnum.PICK_PAY_BILL.getValue());

				pickTrackingService.save(pickTrackingVo);
			}





		}

	}

	@Override
	@Transactional
	public void cancel(Integer id, Integer userId) {
		// 判断订单属于当前用户,再取消
		Pick pick = findById(id);
		if (pick == null || !pick.getUserId().equals(userId)) {
			throw new ControllerException("没有权限取消订单");
			// TODO: 判断当前订单的状态是否 处于可取消状态
		}
		changeOrderStatus(id,PickEnum.PICK_CANCLE.getValue());
		//用户提交之后立即取消时候需要消费掉这条消息，否则消费不了
		MsgConsumeEvent msgConsumeEvent=new MsgConsumeEvent(pick.getId(), MessageEnum.PICK);
		applicationContext.publishEvent(msgConsumeEvent);
	}




	@Override
	@Transactional
	public void receipt(Integer id, Integer userId) {
		// 判断订单属于当前用户,再确认收货
		Pick pick = findById(id);
		if (pick == null || !pick.getUserId().equals(userId)) {
			throw new ControllerException("没有权限取消订单");
			// TODO: 判断当前订单的状态是否 处于可确认收货状态
		}
		changeOrderStatus(id,PickEnum.PICK_FINISH.getValue());

	}

	@Override
	@Transactional
	public void saveOrder(PickVo pickVo) {


		// 保存订单

		// 判断提交的订单是否属于当前用户
		Pick originPick = findById(pickVo.getId());
		if (!(originPick!= null && pickVo.getUserId().equals(originPick.getUserId()))){
			throw new ControllerException("用户无权限访问此页面.");
		}

		// 收货地址保存到历史收货地址表中并把ID 回填到订单表
		if (pickVo.getAddrHistoryId() != null ){
			// 历史地址ID = -1 表示用户修改时未修改地址信息
			if (pickVo.getAddrHistoryId() != -1) {
				ShippingAddressVo sa = shippingAddressService.findVoById(pickVo.getAddrHistoryId());
				ShippingAddressHistory sah = new ShippingAddressHistory();
				BeanUtils.copyProperties(sa, sah);
				sah.setId(null);
				sah.setArea(sa.getFullAdd());
				sah.setAreaId(sa.getAreaId());
				shippingAddressHistoryService.create(sah);
				pickVo.setAddrHistoryId(sah.getId());
			} else {
				pickVo.setAddrHistoryId(null);
			}
		} else {
			throw new ControllerException("地址不能为空.");
		}

		// 保存发票信息 保存前需要先检查下用户发票之前是否存在
		if (pickVo.getInvoice() != null && pickVo.getInvoice().getType()!= null){
			OrderInvoice invoice = orderInvoiceService.findByOrderId(pickVo.getId());
			if (invoice == null) {
				pickVo.getInvoice().setOrderId(pickVo.getId());
				orderInvoiceService.create(pickVo.getInvoice());
			} else {
				// 确认空值的问题
				pickVo.getInvoice().setId(invoice.getId());
				BeanUtils.copyProperties(pickVo.getInvoice(),invoice);
				invoice.setOrderId(pickVo.getId());
				orderInvoiceService.update(invoice);
			}

		}

		update(pickVo);
	}

	@Override
	public ICommonDao<Pick> getDao() {
		return pickDao;
	}



}
