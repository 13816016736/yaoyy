INSERT INTO `survey` VALUES ('1', '资源控制能力（产地有没有专门的人负责备货）', '优 ,一般 ,差', '1', '2017-03-23 17:14:05');
INSERT INTO `survey` VALUES ('2', '行情把控能力（对行情的预测是否敏感）', '优 ,一般 ,差', '1', '2017-03-23 17:14:25');
INSERT INTO `survey` VALUES ('3', '品种熟悉程度（对品种质量的理解，经营年限）', '优 ,一般 ,差', '1', '2017-03-23 17:14:51');
INSERT INTO `survey` VALUES ('4', '物流配送能力（是否有自己的车，是否有长期合作的物流公司）', '优 ,一般 ,差', '1', '2017-03-23 17:15:23');
INSERT INTO `survey` VALUES ('5', '资金实力（能否承受较长账期）', '优 ,一般 ,差', '1', '2017-03-23 17:15:46');

ALTER TABLE `supplier_choice`
CHANGE COLUMN `desc` `survey_desc`  varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL AFTER `choose`;

-- 把认证的供应商信息导入到供应商表中
insert into supplier(phone,name,area,enter_category,company,enter_category_str)
select u.phone as phone, ud.name as name,ud.area as area,ud.category_ids as enter_category,
ud.company as company,(select group_concat(category.name) from category where  FIND_IN_SET(category.id,ud.category_ids)) as enter_category_str
FROM user u
LEFT JOIN user_detail ud on u.id = ud.user_id
WHERE u.type = 2;
-- select group_concat(c.name) as enter_category_str from category c where c.id in(691,65,669);
-- 沪谯 供应商导入
insert into supplier(name,phone,enter_category_str,enter_category)
select t.name as name,t.mobile as phone,group_concat(t.category) as enter_category_str,group_concat(c.id) as enter_category from
(select hs.name,hs.mobile, hs.category from huqiao_supplier hs group by hs.mobile,hs.category)t
left join category c on t.category = c.name
group by t.mobile;
-- 设置供应商默认值. 当前创建时间啥的
-- update supplier SET create_time = now(), status = 0 where id >100;
-- 查找供应商重复的数据
-- select group_concat(id) as ids ,supplier.* from supplier group by phone having count(*)>1;
-- 供应商和用户绑定
update user,supplier
set user.supplier_id = supplier.id
where user.phone=supplier.phone;

-- 资源菜单
delete from role_resources where resources_id in(41,42,43,44);
DELETE FROM `yaoyy`.`resources` WHERE `id`='41';
DELETE FROM `yaoyy`.`resources` WHERE `id`='42';
DELETE FROM `yaoyy`.`resources` WHERE `id`='43';
DELETE FROM `yaoyy`.`resources` WHERE `id`='44';
INSERT INTO `yaoyy`.`resources` (`name`, `type`, `pid`, `permission`, `create_date`) VALUES ('供应商列表', 'button', '40', 'supplier:list', '2017-03-13 13:27:58');

--导供应商excel增加字段
ALTER TABLE `user_track_record`
ADD COLUMN `type`  int(5) NOT NULL DEFAULT 0 COMMENT '跟踪类型：0普通记录，1：核实记录，2：认证记录，3：签约记录' AFTER `member_id`;

update from user_track_record set type=1 where content in('信息审核正确','信息审核不正确');
update from user_track_record set type=2 where content='实地考察认证';

