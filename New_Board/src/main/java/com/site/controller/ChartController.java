package com.site.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.site.dto.GraphDTO;
import com.site.service.ChartService;

@Controller
public class ChartController {
	
	Map<String, Object> map;
	
	GraphDTO  graphDTO;
	
	List<GraphDTO> glist;
	
	@Autowired
	ChartService chartService;

	
	
	/**
	 * 차트 페이지
	 * 
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping("/chart")
	public String graphBoardAccess(HttpSession session, Model model) {
		
		return "chart/chart";
	}

	/**
	 * 일반게시판 일일 게시물 등록수
	 * 
	 * @param session
	 * @param model
	 * @param start 기간검색 시작 일자
	 * @param end 기간검색 종료 일자
	 * @param btDay 시작과 종료일자 차이
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/dobar")
	public List<GraphDTO> dobar(HttpSession session, Model model,@RequestParam @Nullable String start,@RequestParam @Nullable String end,@RequestParam @Nullable String btDay) {
		 
		System.out.println("//////////////////////////////////////");
		System.out.println("start : "+	start);
		System.out.println("end : "+ end);
		System.out.println("byDat : "+ btDay);
		System.out.println("//////////////////////////////////////");
		
		
		return chartService.barList(start,end,btDay);
	}
	
	/**
	 * AJAX게시판 일일 게시물 등록수
	 *
	 * @param start 기간검색 시작일자
	 * @param end 기간검색 종료일자
	 * @return List<GraphDTO>
	 */
	@ResponseBody
	@RequestMapping("/doline")
	public List<GraphDTO> doline(HttpSession session, Model model,@RequestParam @Nullable String start,@RequestParam @Nullable String end,@RequestParam @Nullable String btDay) {
		
		return chartService.lineList(start,end,btDay);
	}
	
	
	
	
	
}
