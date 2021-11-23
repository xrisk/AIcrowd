import { useState, useRef, useEffect } from 'react';

export const useBoundingBox = () => {
  const ref = useRef();
  const [bbox, setBbox] = useState({ right: 0, left: 0 });

  const set = () => setBbox(ref && ref.current ? ref.current.getBoundingClientRect() : {});

  useEffect(() => {
    set();
    window.addEventListener('wheel', set);
    return () => window.removeEventListener('wheel', set);
  }, []);

  return { bbox, ref };
};

export default useBoundingBox;
