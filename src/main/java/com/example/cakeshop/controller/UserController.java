package com.example.cakeshop.controller;

import com.example.cakeshop.constant.SessionKeys;
import com.example.cakeshop.exception.ServiceException;
import com.example.cakeshop.model.Address;
import com.example.cakeshop.model.User;
import com.example.cakeshop.service.AddressService;
import com.example.cakeshop.service.UserService;
import com.example.cakeshop.service.impl.AddressServiceImpl;
import com.example.cakeshop.service.impl.UserServiceImpl;
import com.example.cakeshop.util.ApiRouter;
import com.example.cakeshop.util.JsonUtil;
import com.example.cakeshop.util.SessionUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 用户控制器：登录、注册、个人信息与收货地址。
 * 会话与权限校验由 AccessControlFilter 负责，这里只处理业务。
 */
@WebServlet("/api/user/*")
public class UserController extends AbstractApiServlet {

    private static final long serialVersionUID = 1L;

    private final UserService userService = new UserServiceImpl();
    private final AddressService addressService = new AddressServiceImpl();

    @Override
    protected ApiRouter buildRouter() {
        return new ApiRouter()
                .on("GET", "info", this::userInfo)
                .on("PUT", "info", this::updateInfo)
                .on("PUT", "password", this::updatePassword)
                .on("GET", "address", this::addressList)
                .on("POST", "address", this::addAddress)
                .on("PUT", "address/{addressId}", this::updateAddress)
                .on("DELETE", "address/{addressId}", this::deleteAddress)
                .on("POST", "register", this::register)
                .on("POST", "login", this::login)
                .on("POST", "logout", this::logout);
    }

    private void register(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = new User();
        user.setUsername(request.getParameter("username"));
        user.setPassword(request.getParameter("password"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        userService.register(user);
        JsonUtil.writeSuccess(response, "注册成功");
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = userService.login(request.getParameter("username"), request.getParameter("password"));
        if (user == null) {
            throw new ServiceException("用户名或密码错误");
        }
        HttpSession session = request.getSession();
        session.setAttribute(SessionKeys.USER, user);
        JsonUtil.writeSuccess(response, "登录成功", user);
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        JsonUtil.writeSuccess(response, "登出成功");
    }

    private void userInfo(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User loginUser = requireUser(request);
        User user = userService.findById(loginUser.getId());
        if (user == null) {
            throw ServiceException.notFound("用户不存在");
        }
        JsonUtil.writeSuccess(response, user);
    }

    private void updateInfo(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User loginUser = requireUser(request);
        User user = new User();
        user.setId(loginUser.getId());
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setAvatar(request.getParameter("avatar"));
        if (!userService.update(user)) {
            throw new ServiceException("更新失败");
        }
        User updated = userService.findById(loginUser.getId());
        HttpSession session = request.getSession();
        session.setAttribute(SessionKeys.USER, updated);
        JsonUtil.writeSuccess(response, "更新成功", updated);
    }

    private void updatePassword(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User loginUser = requireUser(request);
        userService.updatePassword(loginUser.getId(), request.getParameter("oldPassword"), request.getParameter("newPassword"));
        JsonUtil.writeSuccess(response, "密码修改成功");
    }

    private void addressList(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User loginUser = requireUser(request);
        List<Address> addresses = addressService.findByUserId(loginUser.getId());
        JsonUtil.writeSuccess(response, addresses);
    }

    private void addAddress(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User loginUser = requireUser(request);
        Address address = readAddress(request);
        address.setUserId(loginUser.getId());
        address.setIsDefault(defaultFlag(request.getParameter("isDefault")));
        if (!addressService.add(address)) {
            throw new ServiceException("添加失败");
        }
        JsonUtil.writeSuccess(response, "添加成功");
    }

    private void updateAddress(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User loginUser = requireUser(request);
        Address address = readAddress(request);
        address.setId(parseId(ApiRouter.pathVariable(request, "addressId")));
        address.setUserId(loginUser.getId());
        String isDefault = request.getParameter("isDefault");
        address.setIsDefault(isDefault == null ? null : defaultFlag(isDefault));
        if (!addressService.update(address)) {
            throw new ServiceException("更新失败");
        }
        JsonUtil.writeSuccess(response, "更新成功");
    }

    private void deleteAddress(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User loginUser = requireUser(request);
        Integer id = parseId(ApiRouter.pathVariable(request, "addressId"));
        if (!addressService.delete(id, loginUser.getId())) {
            throw new ServiceException("删除失败");
        }
        JsonUtil.writeSuccess(response, "删除成功");
    }

    private User requireUser(HttpServletRequest request) {
        User user = SessionUtil.currentUser(request);
        if (user == null) {
            throw new ServiceException(401, "请先登录");
        }
        return user;
    }

    private Address readAddress(HttpServletRequest request) {
        Address address = new Address();
        address.setReceiverName(request.getParameter("receiverName"));
        address.setReceiverPhone(request.getParameter("receiverPhone"));
        address.setProvince(request.getParameter("province"));
        address.setCity(request.getParameter("city"));
        address.setDistrict(request.getParameter("district"));
        address.setDetailAddress(request.getParameter("detailAddress"));
        return address;
    }

    private int defaultFlag(String value) {
        return "1".equals(value) ? 1 : 0;
    }

    private int parseId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            throw new ServiceException("地址ID格式错误");
        }
    }
}
