package com.example.cakeshop.service;

import com.example.cakeshop.model.Address;

import java.util.List;

/**
 * 收货地址业务逻辑接口
 */
public interface AddressService {

    boolean add(Address address);

    List<Address> findByUserId(Integer userId);

    Address findById(Integer id);

    Address findDefault(Integer userId);

    boolean update(Address address);

    boolean delete(Integer id, Integer userId);

    boolean setDefault(Integer id, Integer userId);
}
