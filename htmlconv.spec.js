        var HTMLReport = require('jasmine-xml2html-converter');

        // Call custom report for html output
        testConfig = {
                reportTitle: 'Test Execution Report',
                outputPath: './'
        };
        new HTMLReport().from('./log.xml', testConfig);

