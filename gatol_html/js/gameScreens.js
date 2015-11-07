var Screens = (function() {

	//Prototypes
	function Question(questionText, answer, incorrectAnswers) {
		this.questionText = questionText;
		this.answerText = answer;
		this.incorrectAnswerTexts = incorrectAnswers;
	}

	function Game(questionList, w, h) {
		this.questions = questionList;
		this.width = w;
		this.height = h;
		this.score = 0;
		this.index = 0;

		this.setScore = function(newScore) {
			score = newScore;
		}

		/**
		 * Determines whether the user's answer is correct.
		 * answer is user's answer from the game
		 */
		this.checkAnswer = function(answer) {
			return answer == this.questions[this.index].answer
		};

		/**
		 * Increases the user's score and increments the question number.
		 * Called whenever the user attempts to answer a question.
		 * Returns True if there is a next question or False if no more questions.
		 * isCorrect is whether the user is True or False for the current question 
		 */
		this.isNextQuestion = function(isCorrect) {
			if (isCorrect){
				score += 200;
			}

			this.index += 1;
			return this.index < this.questions.length
		};
		/** 
		 * Returns the current question
		 */
		this.getCurrentQuestion = function() {
			return this.questions[this.index];
		};
	}

	this.game = new Game([],0,0);

	//Ajax methods to communicate with backend

	var getRequest = function(data, suceeded, failed) {
		$.ajax({
			data: JSON.stringify(data),
			dataType: "json",
			url: "https://gatol.herokuapp.com/" + "get_game",
			type: "GET",
			success: suceeded,
			error: failed
		});
	};

	var postRequest = function(data, suceeded, failed) {
		$.ajax({
			data: JSON.stringify(data),
			contentType: "application/json",
            dataType: "json",
			url: "https://gatol.herokuapp.com/" + "update_score",
			type: "POST",
			success: suceeded,
			error: failed
		});
	};



	//Mehtods for transition screens

	var setMainTitleScreen = function() {
		$(".all").hide();
		
		$(".screenTitle").show();
		$(".btnSynopsis").show();
		$(".btnHowTo").show();
		$(".centerBtns .btnQuitGame").show();

		$(".screenTitle").text("Blobbers"); //name of game template.
	};

	var setHowToScreen = function() {
		$(".all").hide();

		$(".screenTitle").show();
		$(".centerText").show();
		$(".bottomBtns .btnMain").show();

		
		var blobberInstructions = "Use W, A, S, and D to move your bubble Up, Left, Down, and Right, respectively. To choose an answer, collide your bubble with the smaller bubble that represents answer."
		
		$(".screenTitle").text("How to Play");
		$(".centerText").text(blobberInstructions);
	};

	var setSynopsisScreen = function() {
		//TEMPORARY QUESTION INITIALIZATION CODE (pretend getRequest actually works)
		//not even sure this is the right place
		var questionList = [new Question("What is two plus two?", "4", ["1", "2", "3", "potato"]),
			new Question("The square root of 1600 is 40.", "true", ["false"]),
			new Question("Which of these is not a color?", "cheese stick", ["red", "orange", "yellow", "green", "blue", "purple"])];
		this.game = new Game(questionList, $(".gameScreen").width(), $(".gameScreen").width()/2);
		console.log("MUTHAFUCKA");
		

		$(".all").hide();

		$(".screenTitle").show();
		$(".qSet").show();
		$(".qSetDescr").show();
		$(".btnNext").show();
		

		$(".screenTitle").text("Synopsis");
	};

	var setQuestionScreen = function(){
		$(".all").hide();

		$(".screenTitle").show();
		$(".currQuestion").show();
		$(".answer").show();
		$(".btnGame").show();

		var question = this.game.getCurrentQuestion();

		$(".screenTitle").text("Question " + (this.game.index+1).toString());
		$(".currQuestion").text(question.questionText);
		$(".answer").text("Choose between the following:");

		$(".answer").append("<div>"+question.answerText+"</div>");
		for (var i = question.incorrectAnswerTexts.length - 1; i >= 0; i--) {
			$(".answer").append("<div>"+question.incorrectAnswerTexts[i]+"</div>");
		};
	};

	var setCorrectScreen = function(){
		$(".all").hide();

		$(".screenTitle").show();
		$(".currQuestion").show();
		$(".answer").show();
		$(".btnNext").show();
		
		$(".screenTitle").text("Correct!");
		$(".answer").text("Good job! You got the correct answer: ");
	};

	var setIncorrectScreen = function() {
		$(".all").hide();

		$(".screenTitle").show();
		$(".currQuestion").show();
		$(".answer").show();
		$(".btnNext").show();
		$(".bottomBtns .btnQuitGame").show();
		
		$(".screenTitle").text("Incorrect");
		$(".answer").text("You chose: " + ". The correct answer is ");
	};

	var setDoneScreen = function() {
		$(".all").hide();

		$(".screenTitle").show();
		$(".centerText").show();
		$(".centerBtns .btnQuitGame").show();
		$(".btnSummary").show();
		$(".centerBtns .btnMain").show();
		
		$(".screenTitle").text("Completed");	
	};


	var answer = function(num) {
		console.log(num);

	}

	var loadGame = function() {
		var game = new Blobbers(document.getElementById("gameScreen"), 
								this.game.width,
								this.game.height,
								this.game.questions[0].incorrectAnswerTexts.length +1, 
								{
									radius:40, 
									numEnemies:0
								},
								answer);
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

		$(".btnGame").click(function() {
			// Goes to start a level of the bubble game. Depends on how we 
			// implement and merge the beginning of the game. Also depends on 
			// which game template was chosed for this game.
			// window.location.href="../public/scripts.testing.html";
			loadGame();
		});

		$(".btnQuitGame").click(function() {
			window.location.href="index.html";
		});
	};

	/**
	 * This will be called when the game is over and it will determine whether
	 * the question was answered correctly or incorrectly.
	 */
	var levelOver = function() {
		// until we figure out how we are going to merge the game level in, this 
		// will not be very robust

		isCorrect = false;

		if (isCorrect) {

			setIncorrectScreen();
		} else {
			setCorrectScreen();
		}
		currGame.isNextQuestion();



		var update = function() {
			console.log("it did it!");
		}
		var updateFailed = function() {
			console.error('update score failed');
		}
		send_data = {student: studentID, gameName: gName, score: currScore, questionIndex: index};

		postRequest(send_data, update, updateFailed) //here to update the score of the current player
	};


	var start = function() {
		//probably initialized in a public method that is called by the screen that chooses the game from the student's game list
		studentID = 0; 
		gName = "";

		var setGame = function(data){
			if (data.status == 1) {
				//make question set and set current question index
			} else if (data.status == -1) {
				console.error('unrecognized game name');
			} else if (data.status == -2) {
				console.error('student does not have access to this game');
			}
		};
		var gameNotReached = function(){
			console.error("game load failure");
		}

		send_data = {student: studentID, gameName: gName};
		getRequest(send_data, setGame, gameNotReached);

        attachHandlers();
        setMainTitleScreen();
        
    };

    return {
        start: start
    };

})();
