import React from 'react';

import AchievementDetail from 'src/components/molecules/AchievementDetail';
import AchievementProgress from 'src/components/molecules/AchievementProgress';
import styles from './achievementListItem.module.scss';
const { main, shareText } = styles;

const AchievementListItem = ({
  icon,
  progress,
  target,
  title,
  description,
  handleShare,
  hideFirst,
  hideBronze,
  showShare,
}) => {
  return (
    <>
      <div className={main}>
        <img src={icon}></img>
        <AchievementProgress progress={progress} target={target} hideBronze={hideBronze} hideFirst={hideFirst} />
        <div style={{ paddingTop: '27px' }}>
          <AchievementDetail title={title} description={description} />
        </div>

        <span
          className={shareText}
          onClick={() => handleShare(title)}
          style={{ visibility: showShare === true || showShare === undefined ? 'visible' : 'hidden' }}>
          Share
        </span>
      </div>
    </>
  );
};
export default AchievementListItem;
