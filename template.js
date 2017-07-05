casper.test.begin('<application>', function(test){
test.done();
});

casper.test.begin('<a href=<URL>><LogicalName></a>', 1, function suite(test) {
    casper.start("<URL>", function() {
        this.waitForSelector('input[name="usernameField"]', function() { 
        this.fillSelectors('form', {
            'input[name="usernameField"]': "<USERNAME>",
            'input[name="passwordField"]': "<PASSWORD>"
        });
	});
   this.capture('<LogicalName>-BeforeLogin.png');

    });
   
    //casper.options.waitTimeout = 15000;   
    //casper.options.logLevel = "debug";
    //casper.options.verbose  ="true"
    //casper.options.pageSettings.loadImages = false;

    casper.waitForSelector('#SubmitButton', function(){
    //this.capture('<LogicalName>-BeforeLogin.png');
    casper.thenClick('#SubmitButton', function() {
        this.echo("Logged in ->");
    });
    this.capture('<LogicalName>-AfterLogin.png');
    });

    casper.waitForText("<LookForValue>", function() {
	//this.capture('<LogicalName>-AfterLogin.png');
        test.assertTitle("<LookForValue>", "Login Check");
    });


    casper.run(function() {
        casper.clear();
        test.done();
        casper.unwait();
        //casper.clear();
        phantom.clearCookies();
        //localStorage.clear();
    });
});
