var Game = function(questions) {
	// set up scene width and height
	this._width = window.innerWidth - 10;
	this._height = window.innerHeight - 10;

	// set up rendering surface
	this.renderer = new PIXI.CanvasRenderer(this._width, this._height);
	document.body.appendChild(this.renderer.view);

	// create the main stage to draw on
	this.stage = new PIXI.Stage();

	// physics shit
	this.world = new p2.World({
		gravity: [0,0]
	});

	// speed
	this.speed = 3000;
	this.turnSpeed = 5;

	window.addEventListener('keydown', function(event) {
		this.handleKeys(event.keyCode, true);
	}.bind(this), false);	
	window.addEventListener('keyup', function(event) {
		this.handleKeys(event.keyCode, false);
	}.bind(this), false);

	this.foodBodies = [];
	this.foodGraphics = [];
	this.answerChoices = [];

	this.questions = questions;
	this.questionNum = 0;

	// Start running the game.
	this.build();
};

Game.prototype = {
	// Build scene and start animating 
	build: function() {
		// set up the boundaries
		this.setupBoundaries();
		// create foods
		this.createFoods();
		//draw blob
		this.createBlob();
		// start first frame
		requestAnimationFrame(this.tick.bind(this));
	},


	// Draw the boundaries of the space arena
	setupBoundaries: function() {
		var walls= new PIXI.Graphics();
		walls.beginFill(0xFFFFFFF, 0.5);
		walls.drawRect(0,0, this._width, 10);
		walls.drawRect(this._width - 10, 10, 10, this._height - 20);
		walls.drawRect(0, this._height - 10, this._width, 10);
		walls.drawRect(0,10,10,this._height - 20);

		// attach the star to the stage
		this.stage.addChild(walls);

	},

	createBlob: function() {
		// create blob object
		this.blob = new p2.Body({
			mass: 1,
			angularVelocity: 0,
			damping: .99,
			angularDamping: .5,
			position:[Math.round(this._width/2),Math.round(this._height/2)]
		});
		this.blobShape = new p2.Circle({radius:40});
		this.blob.addShape(this.blobShape);
		this.world.addBody(this.blob);

		this.blobGraphics = new PIXI.Graphics();

		// draw the blob's body
		this.blobGraphics.beginFill(0xF3801E);
		this.blobGraphics.moveTo(0,0);
		this.blobGraphics.drawCircle(0,-3,40);
		// this.blobGraphics.drawCircle(-2,7,35);
		// this.blobGraphics.drawCircle(10,3,45);
		// this.blobGraphics.drawCircle(-18,-2,20);
		// this.blobGraphics.drawCircle(0,12,40);
		this.blobGraphics.endFill();

		this.stage.addChild(this.blobGraphics);

	},

	createFoods: function() {
		for (i = 0; i < questions[this.questionNum].incorrectAnswers.length + 1; i++) {
			var x = Math.round(Math.random() * this._width);
			var y = Math.round(Math.random() * this._height);
			var vx = (Math.random() - 0.5) * this.speed/20;
			var vy = (Math.random() - 0.5) * this.speed/20;
			var va = 0;//(Math.random() - 0.5) * this.speed/100;
			// create the food physics body
			var food = new p2.Body({
				position: [x,y],
				mass: 1,
				damping: 0,
				angularDamping: 0,
				velocity: [vx, vy],
				angularVelocity: va
			});
			var foodShape = new p2.Circle({radius: 2});
			food.addShape(foodShape);
			this.world.addBody(food);

			// Create the graphics
			var foodGraphics = new PIXI.Graphics();
			foodGraphics.beginFill(0x20c41a);
			foodGraphics.drawCircle(0,0,20);
			foodGraphics.endFill();


			var answerText = new PIXI.Text(String.fromCharCode(65+i), {font: "24px Verdana", fill: "white"});
			// var 

			this.stage.addChild(foodGraphics);
			this.stage.addChild(answerText);

			this.foodBodies.push(food);
			this.foodGraphics.push(foodGraphics);
			this.answerChoices.push(answerText);
			
		}
	},

	handleKeys: function (key, state) {
		switch(key) {
			case 65:
			this.keyLeft = state;
			break;
			case 68:
			this.keyRight = state;
			break;
			case 87:
			this.keyUp = state;
			break;
			case 83:
			this.keyDown = state;
			break;
		}
	},


	getDistance: function(a, b) {
		return Math.sqrt(Math.pow(a.position[0] - b.position[0], 2) + Math.pow(a.position[1] - b.position[1], 2));
	},

	updatePhysics: function () {

		if (this.keyUp) {
			this.blob.force[1] -= this.speed;
		}
		if (this.keyDown) {
			this.blob.force[1] += this.speed;
		}
		if (this.keyRight) {
			this.blob.force[0] += this.speed;
		}
		if (this.keyLeft) {
			this.blob.force[0] -= this.speed;
		}


		this.blobGraphics.x = this.blob.position[0];
		this.blobGraphics.y = this.blob.position[1];

		for (i=0; i < this.foodBodies.length; i++) {
			if (this.getDistance(this.foodBodies[i], this.blob) < 50) {
				console.log("yolo");
			}
		}

		// wrap to other side of screen
		// console.log(this.blob);
		if (this.blob.position[0] > this._width - this.blob.shapes[0].radius) {
			this.blob.position[0] = this._width - this.blob.shapes[0].radius - 1;
		}
		if (this.blob.position[1] > this._height - this.blob.shapes[0].radius) {
			this.blob.position[1] = this._height - this.blob.shapes[0].radius - 1;
		}
		if (this.blob.position[0] < this.blob.shapes[0].radius) {
			this.blob.position[0] = this.blob.shapes[0].radius + 1;
		}
		if (this.blob.position[1] < this.blob.shapes[0].radius) {
			this.blob.position[1] = this.blob.shapes[0].radius + 1;
		}


		// wrap foods
		for (i = 0; i < this.foodBodies.length; i++) {
			if (this.foodBodies[i].position[0] > this._width - this.foodBodies[i].shapes[0].radius) {
				this.foodBodies[i].velocity[0] *= -1;
			}
			if (this.foodBodies[i].position[1] > this._height - this.foodBodies[i].shapes[0].radius) {
				this.foodBodies[i].velocity[1] *= -1;
			}
			if (this.foodBodies[i].position[0] < this.foodBodies[i].shapes[0].radius) {
				this.foodBodies[i].velocity[0] *= -1;
			}
			if (this.foodBodies[i].position[1] < this.foodBodies[i].shapes[0].radius) {
				this.foodBodies[i].velocity[1] *= -1;
			}
		}

		this.blobGraphics.rotation = this.blob.angle;
		// update food positions
		for (var i = 0; i < this.foodBodies.length; i++) {
			this.foodGraphics[i].x = this.foodBodies[i].position[0];
			this.foodGraphics[i].y = this.foodBodies[i].position[1];

			this.answerChoices[i].x = this.foodBodies[i].position[0]-8;
			this.answerChoices[i].y = this.foodBodies[i].position[1]-14;
		}

		this.world.step(1/60);
	},


	//fires at the end of the gameloop to reset and redraw the canvas
	tick: function() {
		this.renderer.render(this.stage);
		requestAnimationFrame(this.tick.bind(this));
		this.updatePhysics();
	}
};