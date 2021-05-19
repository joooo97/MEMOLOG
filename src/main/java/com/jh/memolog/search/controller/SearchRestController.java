package com.jh.memolog.search.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;

import com.jh.memolog.search.model.service.SearchService;

@RestController
public class SearchRestController {
	
	private static final Logger logger = LoggerFactory.getLogger(SearchRestController.class);
	
	@Autowired
	SearchService searchService;
	
}
