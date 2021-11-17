import React from 'react';

import HorizontalScroll from 'src/components/utility/HorizontalScroll';
import styles from './partnerBarLanding.module.scss';

export type PartnerBarLandingProps = {
  logos: [string];
  color?: string;
};

const PartnerBarLanding = ({ logos, color }: PartnerBarLandingProps) => (
  <>
    <div className={styles['partners-bar']}>
      <div className={styles['title']}>Trusted By</div>
      <HorizontalScroll paddingTop="67px" paddingLeft="0px" paddingRight="0px">
        {logos.map(logo => (
          <div className={styles['partners-bar-item']} key={logo}>
            <img
              src={logo}
              className={`${styles['partners-bar-image']} ${color === 'dark' && styles.dark}`}
              alt="logo"
            />
          </div>
        ))}
      </HorizontalScroll>
    </div>
  </>
);

export default PartnerBarLanding;
