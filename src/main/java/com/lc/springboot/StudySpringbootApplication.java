package com.lc.springboot;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan(value = "com.lc.springboot.mapper")
public class StudySpringbootApplication {

	public static void main(String[] args) {
		SpringApplication.run(StudySpringbootApplication.class, args);
	}

}
