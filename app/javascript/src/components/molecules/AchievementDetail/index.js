import React from 'react';
import PropTypes from 'prop-types';

import styles from './achievementDetail.module.scss';
const { mainWrapper, titleText, descriptionText } = styles;

const AchievementDetail = ({ title, description }) => {
  return (
    <>
      <div className={mainWrapper}>
        <div className={titleText}>{title}</div>
        <div className={descriptionText}>{description}</div>
      </div>
    </>
  );
};

AchievementDetail.propTypes = {
  title: PropTypes.string,
  description: PropTypes.string,
};

export default AchievementDetail;
