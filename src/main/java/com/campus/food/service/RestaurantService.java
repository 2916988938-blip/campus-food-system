package com.campus.food.service;

import com.campus.food.entity.Restaurant;
import com.campus.food.mapper.RestaurantMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RestaurantService {

    private final RestaurantMapper restaurantMapper;

    public RestaurantService(RestaurantMapper restaurantMapper) {
        this.restaurantMapper = restaurantMapper;
    }

    public List<Restaurant> getAllRestaurants() {
        return restaurantMapper.findAll();
    }
}
