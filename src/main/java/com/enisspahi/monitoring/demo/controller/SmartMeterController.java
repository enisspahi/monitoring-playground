package com.enisspahi.monitoring.demo.controller;

import com.enisspahi.monitoring.demo.service.SmartMeterService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;

@RestController
@RequestMapping("/smartMeters/")
public class SmartMeterController {

    private static final Logger logger = LoggerFactory.getLogger(SmartMeterController.class);

    private final SmartMeterService service;

    public SmartMeterController(SmartMeterService service) {
        this.service = service;
    }

    @GetMapping("/sum")
    public BigDecimal sum() {
        logger.info("Calculating sum of smart meter values...");
        return service.calculateSum();
    }

    @PostMapping("/randomSmartMeterValues")
    public void randomSmartMeterValues(@RequestParam int meterCount) {
        logger.info("Generating {} random smart meter values...", meterCount);
        service.generateCsvFile(meterCount);
    }

}
