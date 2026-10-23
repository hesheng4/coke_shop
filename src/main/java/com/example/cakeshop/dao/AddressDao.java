package com.example.cakeshop.dao;

import com.example.cakeshop.model.Address;

import java.util.List;

/**
 * 收货地址数据访问接口。默认地址的互斥由 AddressService 用事务保证。
 */
public interface AddressDao {

    int insert(Address address);

    List<Address> findByUserId(Integer userId);

    Address findById(Integer id);

    Address findDefault(Integer userId);

    int update(Address address);

    int delete(Integer id);

    int clearDefault(Integer userId);

    int markDefault(Integer id);
}
