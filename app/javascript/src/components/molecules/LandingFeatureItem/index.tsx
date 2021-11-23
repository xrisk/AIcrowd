import React from 'react';

import styles from './landingFeatureItem.module.scss';
const { main, titleText, descriptionText, textWrapper, border } = styles;

export type LandingFeatureItemProps = {
  title: string;
  description: string;
};

const LandingFeatureItem = ({ title, description }: LandingFeatureItemProps) => (
  <>
    <div className={main}>
      <span className={border}></span>
      <div className={textWrapper}>
        <div className={titleText}>{title}</div>
        <div className={descriptionText}>{description}</div>
      </div>
    </div>
  </>
);

export default LandingFeatureItem;
