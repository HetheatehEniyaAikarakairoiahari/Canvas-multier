export const DrawBoard = {
  mounted() {
    const canvasId = "draw-board-" + this.el.dataset.drawingId;
    this.canvas = document.getElementById(canvasId);
    this.context = this.canvas.getContext('2d');
    this.isDrawing = false;
    
    this.canvas.addEventListener('mousedown', (event) => {
      this.isDrawing = true;
      const rect = this.canvas.getBoundingClientRect();
      this.lastPoint = { x: event.clientX - rect.left, y: event.clientY - rect.top };
    });

    this.canvas.addEventListener('mouseup', () => {
      this.isDrawing = false;
    });

    this.canvas.addEventListener('mousemove', (event) => {
      if (!this.isDrawing) return;
      const rect = this.canvas.getBoundingClientRect();
      let x = event.clientX - rect.left;
      let y = event.clientY - rect.top;
      
      this.pushEvent('draw_line', { start: this.lastPoint, end: { x: x, y: y } });
      this.lastPoint = { x: x, y: y };
    });


    window.addEventListener(`phx:new_line`, (e) => {
      console.log(e)
      this.drawLine(e.detail.start, e.detail.end);
    });
  },

  drawLine(start, end) {
    this.context.beginPath();
    this.context.moveTo(start.x, start.y);
    this.context.lineTo(end.x, end.y);
    this.context.strokeStyle = 'black';
    this.context.lineWidth = 2;
    this.context.stroke();
  }
}