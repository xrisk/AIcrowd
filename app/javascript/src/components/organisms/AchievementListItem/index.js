import React from 'react';

import AchievementDetail from 'src/components/molecules/AchievementDetail';
import AchievementProgress from 'src/components/molecules/AchievementProgress';
import styles from './achievementListItem.module.scss';
const { main, shareText } = styles;

const AchievementListItem = ({ icon, progress, target, title, description, hideFirst, hideBronze, showShare, badgeId }) => {
  return (
    <div>
      <div className={main}>
        <img src={icon}></img>
        <AchievementProgress progress={progress} target={target} hideFirst={hideFirst} hideBronze={hideBronze} />
        <div style={{ paddingTop: '32px' }}>
          <AchievementDetail title={title} description={description} />
        </div>
         {showShare && <span type="button" className={shareText} onClick={()=>openShareBadgesModal(badgeId)}>Share</span>}
      </div>
    </div>
  );
};
export default AchievementListItem;
