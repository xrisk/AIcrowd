import React from 'react';

import styles from './achievementPopup.module.scss';
import ButtonDefault from 'components/atoms/Button/ButtonDefault';
// const {
//   main,
//   badgeIcon,
//   descriptionText,
//   titleText,
//   socialText,
//   socialIconWrapper,
//   iconWrapper,
//   shineWrapper,
// } = styles;

const AchievementPopup = ({ title, description, icon }) => {
  return (
    <div>
      <div className={styles.main}>
        <i className="las la-times"></i>
        <div className={styles.iconWrapper}>
          {/* Show shining animation after badge popup animation */}
          {console.log("testing here")}
          {console.log(styles)}
          <div className={styles.shineWrapper}>
            <span></span>
            <span></span>
          </div>
          <img src={icon} alt="badge icon" className={styles.badgeIcon}></img>
        </div>
        <div className={styles.titleText}>{title}</div>
        <div className={styles.descriptionText}>{description}</div>
        <div className={styles.socialText}>Share with your friends: </div>
        <div className={styles.socialIconWrapper}>
          <img src="/assets/social/twitter.svg" alt="twitter logo"></img>
          <img src="/assets/social/linkedin.svg" alt="linkedin logo"></img>
          <img src="/assets/social/github.svg" alt="github logo"></img>
        </div>
        <ButtonDefault type="primary" text="Continue" />
      </div>
    </div>
  );
};

export default AchievementPopup;
