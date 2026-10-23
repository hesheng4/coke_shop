package com.example.cakeshop.service.impl;

import com.example.cakeshop.dao.AddressDao;
import com.example.cakeshop.dao.impl.AddressDaoImpl;
import com.example.cakeshop.exception.ServiceException;
import com.example.cakeshop.model.Address;
import com.example.cakeshop.service.AddressService;
import com.example.cakeshop.tx.TransactionManager;

import java.util.List;

/**
 * 收货地址实现：默认地址的“取消旧默认 + 设置新默认”放在同一事务里，避免出现两个默认地址。
 */
public class AddressServiceImpl implements AddressService {

    private static final Integer DEFAULT_FLAG = 1;

    private final AddressDao addressDao = new AddressDaoImpl();

    @Override
    public boolean add(Address address) {
        validateRequired(address);
        if (!DEFAULT_FLAG.equals(address.getIsDefault())) {
            return addressDao.insert(address) > 0;
        }
        return TransactionManager.execute(context -> {
            addressDao.clearDefault(address.getUserId());
            return addressDao.insert(address) > 0;
        });
    }

    @Override
    public List<Address> findByUserId(Integer userId) {
        return addressDao.findByUserId(userId);
    }

    @Override
    public Address findById(Integer id) {
        return addressDao.findById(id);
    }

    @Override
    public Address findDefault(Integer userId) {
        return addressDao.findDefault(userId);
    }

    @Override
    public boolean update(Address address) {
        Address stored = addressDao.findById(address.getId());
        if (stored == null || !stored.getUserId().equals(address.getUserId())) {
            throw ServiceException.notFound("地址不存在");
        }
        Address merged = merge(stored, address);
        validateRequired(merged);
        if (!DEFAULT_FLAG.equals(merged.getIsDefault())) {
            return addressDao.update(merged) > 0;
        }
        return TransactionManager.execute(context -> {
            addressDao.clearDefault(merged.getUserId());
            return addressDao.update(merged) > 0;
        });
    }

    @Override
    public boolean delete(Integer id, Integer userId) {
        Address stored = addressDao.findById(id);
        if (stored == null || !stored.getUserId().equals(userId)) {
            throw ServiceException.notFound("地址不存在");
        }
        return addressDao.delete(id) > 0;
    }

    @Override
    public boolean setDefault(Integer id, Integer userId) {
        Address stored = addressDao.findById(id);
        if (stored == null || !stored.getUserId().equals(userId)) {
            throw ServiceException.notFound("地址不存在");
        }
        return TransactionManager.execute(context -> {
            addressDao.clearDefault(userId);
            return addressDao.markDefault(id) > 0;
        });
    }

    /**
     * 前端只回传被修改的字段，未传的字段沿用库中原值，避免非空列被写成 NULL。
     */
    private Address merge(Address stored, Address incoming) {
        Address merged = new Address();
        merged.setId(stored.getId());
        merged.setUserId(stored.getUserId());
        merged.setReceiverName(firstNonEmpty(incoming.getReceiverName(), stored.getReceiverName()));
        merged.setReceiverPhone(firstNonEmpty(incoming.getReceiverPhone(), stored.getReceiverPhone()));
        merged.setProvince(firstNonEmpty(incoming.getProvince(), stored.getProvince()));
        merged.setCity(firstNonEmpty(incoming.getCity(), stored.getCity()));
        merged.setDistrict(firstNonEmpty(incoming.getDistrict(), stored.getDistrict()));
        merged.setDetailAddress(firstNonEmpty(incoming.getDetailAddress(), stored.getDetailAddress()));
        merged.setIsDefault(incoming.getIsDefault() != null ? incoming.getIsDefault() : stored.getIsDefault());
        merged.setCreateTime(stored.getCreateTime());
        merged.setUpdateTime(stored.getUpdateTime());
        return merged;
    }

    private void validateRequired(Address address) {
        if (isBlank(address.getReceiverName())) {
            throw new ServiceException("收货人不能为空");
        }
        if (isBlank(address.getReceiverPhone())) {
            throw new ServiceException("联系电话不能为空");
        }
    }

    private String firstNonEmpty(String incoming, String stored) {
        return isBlank(incoming) ? stored : incoming;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
