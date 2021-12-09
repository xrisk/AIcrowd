import React, { useRef, useState, useEffect, useLayoutEffect } from 'react';
import { ParticleMap } from 'src/libs/particleMap';
import worldMap from './worldGeo.json';

import styles from './landingCommunityMap.module.scss';

const LandingCommunityMap = ({ communityMembersList, width }) => {
  const [data, setData] = useState({});
  const [dimensions, setDimensions] = React.useState({});
  const canvasRef = useRef();
  const communityMemberRef = useRef();
  const communityMembersMapRef = useRef();

  useLayoutEffect(() => {
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
    var filteredFeatures = worldMap.features.filter(function(feature) {
      return feature.id !== 'ATA';
    });

    // setData(worldMap);
    setData({ type: 'FeatureCollection', features: filteredFeatures });
  }, []);

  useEffect(() => {
    if (canvasRef && communityMemberRef && communityMembersMapRef && data?.features) {
      const mapContainer = communityMembersMapRef.current;
      let canvas = canvasRef.current;

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

      const memberNodeList = communityMembersMapRef.current.childNodes;

      // Remove all member before creating new
      [...memberNodeList].map(node => {
        if (node.className === styles['community-member']) {
          node?.remove();
        }
      });

      for (i = 0; i < communityMembersList?.length; i++) {
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

        communityMembersMapRef.current.append(member);
      }
    }
  }, [width, data]);

  return (
    <div className={styles['community-members']}>
      <div className={styles['community-members-map']} ref={communityMembersMapRef}>
        <canvas id="world-map" ref={canvasRef}></canvas>
      </div>
    </div>
  );
};

export default LandingCommunityMap;
