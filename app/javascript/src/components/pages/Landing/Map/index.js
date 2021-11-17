import React, { useEffect, useRef, useState } from 'react';
import { ParticleMap } from 'src/libs/particleMap';
import worldMap from './worldGeo.json';

import styles from './map.module.scss';

const Map = ({ communityMembersList }) => {
  const [data, setData] = useState(worldMap);
  const [dimensions, setDimensions] = React.useState({});
  const canvasRef = useRef();
  const communityMemberRef = useRef();
  const communityMembersMapRef = useRef();

  useEffect(() => {
    function handleResize() {
      setDimensions({
        height: window.innerHeight,
        width: window.innerWidth,
      });
    }

    window.addEventListener('resize', handleResize);

    return () => {
      window.removeEventListener('resize', handleResize);
    };
  });

  useEffect(() => {
    setData(worldMap);
    if (canvasRef && communityMemberRef && communityMembersMapRef) {
      const mapContainer = communityMembersMapRef.current;
      let canvas = canvasRef.current;

      // const context = canvas.getContext('2d');
      // context.clearRect(0, 0, canvas.width, canvas.height);
      // mapContainer.removeChild(canvas);

      // const canvas = document.createElement('canvas');
      // canvas.setAttribute('id', 'map-canvas');
      // canvas.setAttribute('height', canvas.scrollHeight);
      // canvas.setAttribute('width', canvas.scrollWidth);
      // mapContainer.appendChild(canvas);

      canvas.height = canvas.scrollHeight;
      canvas.width = canvas.scrollWidth;

      var drawPointFunc = function(coords, idx, status) {
        if (status == 2) return false;
      };

      var params = {
        canvas: canvas,
        padding: 0,
        stretch: false,
        pixelResolution: 5,
        drawPointFunc: drawPointFunc,
        foregroundColor: '#F0524D',
      };

      var communityMap = new ParticleMap(data, params);

      var i;
      let el;
      for (i = 0; i < communityMembersList.length; i++) {
        el = communityMembersList[i];
        const lat = el.lat * 1.0;
        const long = el.lon * 1.0;
        var screenCoords = communityMap.getScreenCoordFromMapCoord([lat, long]);
        var translateString = 'translate(' + screenCoords[0] + 'px, ' + -1 * screenCoords[1] + 'px)';

        const member = document.createElement('div');
        const img = document.createElement('img');
        img.setAttribute('src', el.image);
        member.classList.add(styles['community-member']);
        member.setAttribute('data-name', el.name);
        member.setAttribute('data-lat', el.lat);
        member.setAttribute('data-lon', el.lon);
        member.appendChild(img);
        member.style.transform = translateString;
        member.style['-webkit-transform'] = translateString;
        member.style['display'] = 'block';

        const membersNodeLength = communityMembersMapRef.current.childNodes.length;

        // Prevent duplicate members display on re-render.
        if (membersNodeLength <= communityMembersList.length) {
          communityMembersMapRef.current.appendChild(member);
        }
      }
    }
  }, [dimensions]);

  return (
    <div className={styles['community-members']}>
      <div className={styles['community-members-map']} ref={communityMembersMapRef}>
        <canvas id="world-map" ref={canvasRef}></canvas>
      </div>
    </div>
  );
};

export default Map;
