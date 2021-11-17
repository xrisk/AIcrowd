import React, { useRef, useEffect, useCallback } from 'react';

import useBoundingBox from 'src/hooks/useBoundingBox';

import styles from './horizontalScroll.module.scss';
const { main, container, scroll, scrollContainer } = styles;

type HorizontalScrollProps = {
  children: React.ReactNode;
  type?: string;
  paddingLeft?: string;
  paddingRight?: string;
  paddingTop?: string;
};

const HorizontalScroll = ({ children, type, paddingLeft, paddingRight, paddingTop }: HorizontalScrollProps) => {
  const { bbox: firstItemRect, ref: firstRef } = useBoundingBox();
  const { bbox: lastItemRect, ref: lastRef } = useBoundingBox();
  const scrollRef = useRef(null);
  const mouseScrollContainer = useRef(null);

  let isDown = false;
  let scrollX;
  let scrollLeft;

  const handleMouseUp = useCallback(e => {
    isDown = false;
    scrollRef.current.classList.remove('active');
  }, []);

  const handleMouseLeave = useCallback(e => {
    isDown = false;
    scrollRef.current.classList.remove('active');
  }, []);

  const handleMouseDown = useCallback(e => {
    e.preventDefault();

    isDown = true;
    scrollRef.current.classList.add('active');
    scrollX = e.pageX - scrollRef.current.offsetLeft;
    scrollLeft = scrollRef.current.scrollLeft;
  }, []);

  const handleMouseMove = useCallback(e => {
    if (!isDown) return;
    e.preventDefault();
    var element = e.pageX - scrollRef.current.offsetLeft;
    var scrolling = (element - scrollX) * 2;
    scrollRef.current.scrollLeft = scrollLeft - scrolling;
  }, []);

  useEffect(() => {
    if (scrollRef) {
      if (scrollRef.current) {
        // Mouse Up Function
        scrollRef.current.addEventListener('mouseup', e => handleMouseUp(e));

        // Mouse Leave Function
        scrollRef.current.addEventListener('mouseleave', e => handleMouseLeave(e));

        // Mouse Down Function
        scrollRef.current.addEventListener('mousedown', e => handleMouseDown(e));

        // Mouse Move Function
        scrollRef.current.addEventListener('mousemove', e => handleMouseMove(e));

        return () => {
          scrollRef.current?.removeEventListener('mouseup', handleMouseUp);
          scrollRef.current?.removeEventListener('mouseleave', handleMouseLeave);
          scrollRef.current?.removeEventListener('mousedown', handleMouseDown);
          scrollRef.current?.removeEventListener('mousemove', handleMouseMove);
        };
      }
    }
  }, [scrollRef]);

  // -------------- handle horizontal scroll with mouse -----------------------
  const handleScroll = e => {
    if (mouseScrollContainer) {
      const container = mouseScrollContainer.current;

      // gets the boundingRect positions for container
      const containerRect = container.getBoundingClientRect();
      // calculate distance between last element & container end;
      const offsetRight = lastItemRect.right - containerRect.right;
      // calculate distance between first element & container start;
      const offsetLeft = firstItemRect.left - containerRect.left;

      // if deltaX is true probably using trackpad
      // if true then scroll on sliding left / right on trackpad
      if (Math.abs(e.deltaX)) {
        if (e.deltaX > 0) {
          container.scrollLeft += 35;
        } else {
          container.scrollLeft -= 35;
        }
      }

      if (e.deltaY > 0) {
        container.scrollLeft += 35;
        // continue scrolling page if last element of horizontal scroll
        //item is visible
        if (offsetRight > 0) {
          e.preventDefault();
        }
      } else {
        container.scrollLeft -= 35;
        // continue scrolling page if first element of horizontal scroll
        //item is visible
        if (offsetLeft < 0) {
          e.preventDefault();
        }
      }
    }
  };

  useEffect(() => {
    if (mouseScrollContainer) {
      mouseScrollContainer?.current?.addEventListener('wheel', handleScroll, { passive: false });
    }
    if (mouseScrollContainer) {
      mouseScrollContainer?.current?.addEventListener('touchstart', handleScroll, { passive: false });
    }

    return () => {
      if (mouseScrollContainer) {
        mouseScrollContainer?.current?.removeEventListener('wheel', handleScroll);
        mouseScrollContainer?.current?.removeEventListener('touchstart', handleScroll, { passive: false });
      }
    };
  });

  if (type === 'drag') {
    // scroll with dragging clicking & dragging mouse
    return (
      <>
        <main className={main}>
          <div className={`${container}`}>
            <div className={scroll} ref={scrollRef}>
              {children}
            </div>
          </div>
        </main>
      </>
    );
  } else {
    // scroll with mouse wheel
    return (
      <>
        <main
          className={scrollContainer}
          ref={mouseScrollContainer}
          style={{ paddingLeft: paddingLeft, paddingRight: paddingRight, paddingTop: paddingTop }}>
          <div ref={firstRef}></div>
          {children}
          <div ref={lastRef}></div>
        </main>
      </>
    );
  }
};

export default HorizontalScroll;
