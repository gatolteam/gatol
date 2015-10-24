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
	}

	var setSynopsisScreen = function() {
		$(".all").hide();

		$(".title").show();
		$(".qSet").show();
		$(".qSetDescr").show();
		$(".btnNext").show();
		

		$(".title").text("Synopsis");
	}

	var setQuestionScreen = function(){
		$(".all").hide();

		$(".title").show();
		$(".currQuestion").show();
		$(".answerForm").show();
		$(".btnGame").show();
		

		$(".title").text("Question #");
	}

	var setCorrectScreen = function(){
		$(".all").hide();

		$(".title").show();
		$(".currQuestion").show();
		$(".answer").show();
		$(".btnNext").show();
		
		$(".title").text("Correct!");
	}

	var setIncorrectScreen = function() {
		$(".all").hide();

		$(".title").show();
		$(".currQuestion").show();
		$(".answer").show();
		$(".btnNext").show();
		$(".bottomBtns .btnQuitGame").show();
		
		$(".title").text("Incorrect");	
	}

	var setWinScreen = function() {
		$(".all").hide();

		$(".title").show();
		$(".centerText").show();
		$(".centerBtns .btnQuitGame").show();
		$(".btnSummary").show();
		$(".centerBtns .btnMain").show();
		
		$(".title").text("You Won!");	
	}


	var attachHandlers = function() {
		//pretty much just button clicks at this point
	}




var start = function(){
        // attachHandlers();
        setMainTitleScreen();
        setHowToScreen();
        setSynopsisScreen();
        setQuestionScreen();
        setCorrectScreen();
        setIncorrectScreen();
        setWinScreen();
    };

    return {
        start: start
    };

})();
