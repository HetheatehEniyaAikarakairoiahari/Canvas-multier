let Hooks = {}

Hooks.DrawBoard = {
  mounted() {
    this.canvas = document.getElementById('draw-board');
    this.context = this.canvas.getContext('2d');
    this.isDrawing = false;
    this.lastPoint = { x: 0, y: 0 };

    // Set the stroke color to black
    this.context.strokeStyle = "#000000";

    this.canvas.addEventListener('mousedown', (event) => {
      this.isDrawing = true;
      this.lastPoint = { x: event.pageX - this.canvas.offsetLeft, y: event.pageY - this.canvas.offsetTop };
    });

    this.canvas.addEventListener('mouseup', () => {
      this.isDrawing = false;
    });

    this.canvas.addEventListener('mousemove', (event) => {
      if (!this.isDrawing) return;
      let x = event.pageX - this.canvas.offsetLeft;
      let y = event.pageY - this.canvas.offsetTop;
      this.pushEvent('draw_line', { start: this.lastPoint, end: { x: x, y: y } });
      this.drawLine(this.lastPoint, { x: x, y: y });
      this.lastPoint = { x: x, y: y };
    });
  },

  drawLine(start, end) {
    this.context.beginPath();
    this.context.moveTo(start.x, start.y);
    this.context.lineTo(end.x, end.y);
    this.context.stroke();
  }
}

let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks });
liveSocket.connect();