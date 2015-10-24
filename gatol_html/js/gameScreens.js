var Screens = (function() {


	var setMainTitleScreen = function() {
		$(".all").hide();
		
		$(".title").show();
		$(".btnSynopsis").show();
		$(".btnHowTo").show();
		$(".centerBtns .btnQuitGame").show();

		$(".title").text("Blobbers"); //name of game template.
	};

	var setHowToScreen = function() {
		$(".all").hide();

		$(".title").show();
		$(".centerText").show();
		$(".bottomBtns .btnMain").show();

		
		$(".title").text("How to Play");
	};

	var setSynopsisScreen = function() {
		$(".all").hide();

		$(".title").show();
		$(".qSet").show();
		$(".qSetDescr").show();
		$(".btnNext").show();
		

		$(".title").text("Synopsis");
	};

	var setQuestionScreen = function(){
		$(".all").hide();

		$(".title").show();
		$(".currQuestion").show();
		$(".answerForm").show();
		$(".btnGame").show();
		

		$(".title").text("Question #");
	};

	var setCorrectScreen = function(){
		$(".all").hide();

		$(".title").show();
		$(".currQuestion").show();
		$(".answer").show();
		$(".btnNext").show();
		
		$(".title").text("Correct!");
	};

	var setIncorrectScreen = function() {
		$(".all").hide();

		$(".title").show();
		$(".currQuestion").show();
		$(".answer").show();
		$(".btnNext").show();
		$(".bottomBtns .btnQuitGame").show();
		
		$(".title").text("Incorrect");	
	};

	var setDoneScreen = function() {
		$(".all").hide();

		$(".title").show();
		$(".centerText").show();
		$(".centerBtns .btnQuitGame").show();
		$(".btnSummary").show();
		$(".centerBtns .btnMain").show();
		
		$(".title").text("Completed");	
	};


	var attachHandlers = function() {
		//pretty much just button clicks at this point
		
		$(".btnHowTo").click(function() {
			setHowToScreen();
		});

		$(".btnSynopsis").click(function() {
			setSynopsisScreen();
		});

		$(".btnMain").click(function() {
			setMainTitleScreen();
			//if done from HowToScreen this is all that needs to be done
			//but if done from Done Screen should anything be reset?
		});

		$(".btnNext").click(function() {
			//Increment Question number

			//If question number is the question limit -> setDoneScreen(); else
			setQuestionScreen(); 
		});

		$(".btnPlay").click(function() {
			// Goes to start a level of the bubble game. Depends on how we 
			// implement and merge the beginning of the game. Also depends on 
			// which game template was chosed for this game. 
		});

		$(".btnQuitGame").click(function() {
			window.location.href="index.html";
		});
	};




var start = function(){
        attachHandlers();
        setMainTitleScreen();
        // setHowToScreen();
        // setSynopsisScreen();
        // setQuestionScreen();
        // setCorrectScreen();
        // setIncorrectScreen();
        // setDoneScreen();
    };

    return {
        start: start
    };

})();
