import React, { useRef, useState, useEffect } from 'react';

import styles from './landingCommunityMap.module.scss';
const { communityMapWrapper } = styles;

export type LandingCommunityMapProps = {
  communityMap: string;
  communityMapAvatar: string;
};

const LandingCommunityMap = ({ communityMap, communityMapAvatar }: LandingCommunityMapProps) => {
  const [isIntersecting, setIntersecting] = useState(false);
  const mapRef = useRef(null);

  useEffect(() => {
    const observer = new IntersectionObserver(([entry]) => setIntersecting(entry.isIntersecting));
    observer.observe(mapRef.current);
    return () => {
      observer.disconnect();
    };
  }, [mapRef]);

  useEffect(() => {
    if (mapRef?.current) {
      const map = mapRef.current;
      if (isIntersecting) {
        map.lastElementChild.style['display'] = 'none';
        map.firstElementChild.style['opacity'] = 1;
      } else if (!isIntersecting) {
        map.lastElementChild.style['display'] = 'block';
        map.firstElementChild.style['opacity'] = 0;
      }
    }
  }, [mapRef, isIntersecting]);
  return (
    <>
      <div ref={mapRef} className={communityMapWrapper} style={{ backgroundImage: `url(${communityMap})` }}>
        <img src={communityMapAvatar} style={{ opacity: 0 }}></img>
        <img src="https://images.aicrowd.com/images/landing_page/map-empty.png"></img>
      </div>
    </>
  );
};

export default LandingCommunityMap;
