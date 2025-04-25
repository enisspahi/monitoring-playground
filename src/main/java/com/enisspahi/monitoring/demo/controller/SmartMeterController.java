package com.enisspahi.monitoring.demo.controller;

import org.springframework.web.bind.annotation.*;

import java.io.BufferedWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Random;

@RestController
@RequestMapping("/smartMeters/")
public class SmartMeterController {

    private static final Path CSV_PATH = Paths.get(".out/smartmeter-readings.csv");

    private final Random random = new Random();

    @GetMapping("/sum")
    public BigDecimal sumSmartMeterValues() {
        try (var lines = Files.lines(CSV_PATH)) {
            var readings = lines
                    .map(String::trim)
                    .filter(line -> !line.isEmpty())
                    .map(BigDecimal::new)
                    .toList();

            return readings.stream().reduce(BigDecimal.ZERO, BigDecimal::add);
        } catch (IOException e) {
            throw new RuntimeException("Failed to read CSV: " + e.getMessage());
        }
    }

//  Fixes out of memory error
//    @GetMapping("/sum")
//    public BigDecimal sumSmartMeterValues() {
//        try (BufferedReader reader = Files.newBufferedReader(CSV_PATH)) {
//            BigDecimal sum = BigDecimal.ZERO;
//            String line;
//
//            while ((line = reader.readLine()) != null) {
//                line = line.trim();
//                if (!line.isEmpty()) {
//                    sum = sum.add(new BigDecimal(line));
//                }
//            }
//
//            return sum;
//        } catch (IOException e) {
//            throw new RuntimeException("Failed to read CSV: " + e.getMessage(), e);
//        }
//    }

    @PostMapping("/randomSmartMeterValues")
    public String generateCsvFile(@RequestParam int meterCount) {
        if (meterCount <= 0) {
            return "Meter count must be greater than 0.";
        }

        try (BufferedWriter writer = Files.newBufferedWriter(CSV_PATH)) {
            for (int i = 0; i < meterCount; i++) {
                var reading = generateRandomKWhReading();
                writer.write(reading.toPlainString());
                writer.newLine();
            }
            return "CSV file generated with " + meterCount + " readings.";
        } catch (IOException e) {
            throw new RuntimeException("Failed to write CSV: " + e.getMessage());
        }
    }

    private BigDecimal generateRandomKWhReading() {
        // Simulate realistic smart meter readings between 0.1 and 10.0 kWh
        double value = 0.1 + (10.0 - 0.1) * random.nextDouble();
        return BigDecimal.valueOf(value).setScale(3, RoundingMode.HALF_UP);
    }
}
