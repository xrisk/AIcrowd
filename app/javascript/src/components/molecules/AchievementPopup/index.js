import React from 'react';
import PropTypes from 'prop-types';

import styles from './achievementPopup.module.scss';
import ButtonDefault from 'src/components/atoms/Button/ButtonDefault';
const {
  main,
  badgeIcon,
  descriptionText,
  titleText,
  socialText,
  socialIconWrapper,
  iconWrapper,
  shineWrapper,
} = styles;

const AchievementPopup = ({ title, description, icon, handleClick, url, badgeTitle, socialMessage, badgeId }) => {
  return (
    <>
      <div className={main}>
        <i className="las la-times" onClick={()=>window.hideBadgesModal(badgeId)}></i>
        <div className={iconWrapper}>
          {/* Show shining animation after badge popup animation */}
          <div className={shineWrapper}>
            <span></span>
            <span></span>
          </div>
          <img src={icon} alt="badge icon" className={badgeIcon}></img>
        </div>
        <div className={titleText}>{title}</div>
        <div className={descriptionText}>{description}</div>
        <div className={socialText}>Share with your friends: </div>
        <div className={socialIconWrapper}>
          <img src="/assets/misc/badge-twitter.svg" alt="twitter logo" onClick={()=>window.shareBadgeTwitter(url, socialMessage)}></img>
          <img src="/assets/misc/badge-linkedin.svg" alt="linkedin logo" onClick={()=>window.shareBadgeLinkedin(url, badgeTitle, socialMessage)}></img>
          <img src="/assets/misc/badge-facebook.svg" alt="facebook logo" onClick={()=>window.shareBadgefb(url, socialMessage)}></img>

        </div>
        <ButtonDefault type="primary" text="Continue" handleClick={()=>window.hideBadgesModal(badgeId)} />
      </div>
    </>
  );
};

AchievementPopup.propTypes = {
  title: PropTypes.string,
  description: PropTypes.string,
  icon: PropTypes.string,
};

export default AchievementPopup;
