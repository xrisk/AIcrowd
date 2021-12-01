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

const AchievementPopup = ({ title, description, icon, handleClick }) => {
  return (
    <>
      <div className={main}>
        <i className="las la-times" onClick={handleClick}></i>
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
          <a href="">
            <img src="https://images.aicrowd.com/images/landing_page/twitter.svg" alt="twitter logo"></img>
          </a>
          <a href="">
            <img src="https://images.aicrowd.com/images/landing_page/linkedin.svg" alt="linkedin logo"></img>
          </a>
          <a href="">
            <img src="https://images.aicrowd.com/images/landing_page/facebook.svg" alt="facebook logo"></img>
          </a>
        </div>
        <ButtonDefault type="primary" text="Continue" handleClick={handleClick} />
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
