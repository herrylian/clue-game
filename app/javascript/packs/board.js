var pieces = [];
var InitGrid = 3;
var gridHeight = 8;
var BlackPieces = "#000000";
var WhitePieces = "#ffffff";
var canvas;
var ctx;
var dice;

dice = document.getElementById("dice");
dice.hide();

function Box(row, column, color) {
  this.row = row;
  this.column = column;
  this.color = color;
}

window.draw2 = function() {

  canvas = document.getElementById("myCanvas2");
  ctx = canvas.getContext("2d");


  for (var i = 0; i < InitGrid; i++) {
    for (var j = (i + 1) % 2; j < gridHeight; j = j + 2) {
      pieces.push(new Box(i, j, BlackPieces));
    }
  }

  for (var i = gridHeight - 1; i >= gridHeight - InitGrid; i--) {
    for (var j = (i + 1) % 2; j < gridHeight; j = j + 2) {
      pieces.push(new Box(i, j, WhitePieces));
    }
  }

  paintGrid();

}

function paintGrid() {

  ctx.clearRect(0, 0, canvas.width, canvas.height);

  for (var x = 0; x <= canvas.width; x += 50) {
    ctx.moveTo(x, 0);
    ctx.lineTo(x, canvas.width);
  }

  for (var y = 0; y <= canvas.height; y += 50) {
    ctx.moveTo(0, y);
    ctx.lineTo(canvas.height, y);
  }

  ctx.strokeStyle = "Black";
  ctx.stroke();

  for (var i = 0; i < pieces.length; i++) {
    paintPlayer(pieces[i], pieces[i].color);
  }


}

function paintPlayer(p, color) {
  ctx.beginPath();
  ctx.arc(25 + p.column * 50, 25 + p.row * 50, 19, 0, (Math.PI * 2), true);
  ctx.stroke();
  ctx.fillStyle = color;
  ctx.fill();
}
