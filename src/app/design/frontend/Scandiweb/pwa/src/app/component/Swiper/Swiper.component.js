import React, { Component } from 'react';
import './Swiper.style';

class SwipeableListItem extends Component {

  constructor(props) {
    super(props);

    this.listElement = null;
    this.wrapper = null;
    this.background = null;

    this.onMouseMove = this.onMouseMove.bind(this);
    this.onTouchMove = this.onTouchMove.bind(this);
    this.onDragStartMouse = this.onDragStartMouse.bind(this);
    this.onDragStartTouch = this.onDragStartTouch.bind(this);
    this.onDragEndMouse = this.onDragEndMouse.bind(this);
    this.onDragEndTouch = this.onDragEndTouch.bind(this);
    this.onDragEnd = this.onDragEnd.bind(this);
    this.updatePosition = this.updatePosition.bind(this);
    this.onSwiped = this.onSwiped.bind(this);
  }

  dragStartX = 0
  left = 0
  dragged = false

  // DOM Refs
  listElement
  wrapper
  background

  onDragStartMouse(evt) {
    this.onDragStart(evt.clientX);
    window.addEventListener("mousemove", this.onMouseMove);
  }

  onDragStartTouch(evt) {
    const touch = evt.targetTouches[0];
    this.onDragStart(touch.clientX);
    window.addEventListener("touchmove", this.onTouchMove);
  }

  onDragStart(clientX) {
    this.dragged = true;
    this.dragStartX = clientX;
    this.listElement.className = "swiperListItem";

    requestAnimationFrame(this.updatePosition);
  }
  onMouseMove(evt) {
    const left = evt.clientX - this.dragStartX;
    if (left < 0) {
      this.left = left;
    }
  }

  onTouchMove(evt) {
    const touch = evt.targetTouches[0];
    const left = touch.clientX - this.dragStartX;
    if (left < 0) {
      this.left = left;
    }
  }
  onDragEndMouse(evt) {
    window.removeEventListener("mousemove", this.onMouseMove);
    this.onDragEnd();
  }

  onDragEndTouch(evt) {
    window.removeEventListener("touchmove", this.onTouchMove);
    this.onDragEnd();
  }

  onDragEnd() {
    if (this.dragged) {
      this.dragged = false;

      const threshold = this.props.threshold || 0.3;

      if (this.left < this.listElement.offsetWidth * threshold * -1) {
        this.left = -this.listElement.offsetWidth * 2;
        this.onSwiped();
      } else {
        this.left = 0;
      }
      this.listElement.className = "swiperBouncingListItem";

      this.listElement.style.transform = `translateX(${this.left}px)`;
    }
  }
  onSwiped() {
    if (this.props.onSwipe) {
      this.props.onSwipe();
    }
  }

  componentDidMount() {
    window.addEventListener("mouseup", this.onDragEndMouse);
    window.addEventListener("touchend", this.onDragEndTouch);
  }
  componentWillUnmount() {
    window.removeEventListener("mouseup", this.onDragEndMouse);
    window.removeEventListener("touchend", this.onDragEndTouch);
  }
  updatePosition() {
    if (this.dragged) requestAnimationFrame(this.updatePosition);

    const now = Date.now();
    const elapsed = now - this.startTime;


    if (this.dragged && elapsed > this.fpsInterval) {
      this.listElement.style.transform = `translateX(${this.left}px)`;

      const opacity = (Math.abs(this.left) / 100).toFixed(2);
      if (opacity < 1 && opacity.toString() !== this.background.style.opacity) {
        this.background.style.opacity = opacity.toString();
      }
      if (opacity >= 1) {
        this.background.style.opacity = "1";
      }

      this.startTime = Date.now();
    }
  }

  render() {
    return (
      <>
        <div className="swiperWrapper" ref={div => (this.wrapper = div)}>
          <div ref={div => (this.background = div)} className="swiperBackground">
            {this.props.background ? this.props.background : <span className="swiperDeleteText">Delete</span>}
          </div>
          <div ref={div => (this.listElement = div)} className="swiperListItem">
            <div
              ref={div => (this.listElement = div)}
              onMouseDown={this.onDragStartMouse}
              onTouchStart={this.onDragStartTouch}
            >
              {this.props.children}
            </div>
          </div>
        </div>
      </>
    )
  }
}

export default SwipeableListItem