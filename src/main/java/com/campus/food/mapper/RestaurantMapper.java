package com.campus.food.mapper;

import com.campus.food.entity.Restaurant;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface RestaurantMapper {

  @Select("SELECT * FROM restaurants WHERE status = 1")
    List<Restaurant> findAll();

}