package com.site.service;

import java.util.List;

import com.site.dto.GraphDTO;

public interface ChartService {

	List<GraphDTO> barList();

	List<GraphDTO> lineList();
}
