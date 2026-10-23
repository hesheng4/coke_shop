package com.example.cakeshop.model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 优惠券实体类
 */
public class Coupon {

    private Integer id;
    private String name;
    private Integer type; // 1满减/2折扣
    private BigDecimal minAmount;
    private BigDecimal discount;
    private Date startTime;
    private Date endTime;
    private Integer total;
    private Integer used;
    private Integer status;
    private Date createTime;

    // 关联字段
    private Integer userCouponId;
    private Integer userCouponStatus;

    public Coupon() {
    }

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public BigDecimal getMinAmount() {
        return minAmount;
    }

    public void setMinAmount(BigDecimal minAmount) {
        this.minAmount = minAmount;
    }

    public BigDecimal getDiscount() {
        return discount;
    }

    public void setDiscount(BigDecimal discount) {
        this.discount = discount;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public Integer getUsed() {
        return used;
    }

    public void setUsed(Integer used) {
        this.used = used;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Integer getUserCouponId() {
        return userCouponId;
    }

    public void setUserCouponId(Integer userCouponId) {
        this.userCouponId = userCouponId;
    }

    public Integer getUserCouponStatus() {
        return userCouponStatus;
    }

    public void setUserCouponStatus(Integer userCouponStatus) {
        this.userCouponStatus = userCouponStatus;
    }

    /**
     * 获取优惠券类型文本
     */
    public String getTypeText() {
        if (type == 1) {
            return "满" + minAmount + "减" + discount;
        } else if (type == 2) {
            return discount + "折";
        }
        return "";
    }
}
