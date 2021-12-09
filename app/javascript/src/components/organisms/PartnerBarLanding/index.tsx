import React from 'react';
import Image from 'next/image';

import HorizontalScroll from 'src/components/utility/HorizontalScroll';
import styles from './partnerBarLanding.module.scss';
import useMediaQuery from 'src/hooks/useMediaQuery';
import { sizes } from 'src/constants/screenSizes';

const { small, large } = sizes;

export type PartnerBarLandingProps = {
  logos: [string];
  color?: string;
};

const PartnerBarLanding = ({ logos, color }: PartnerBarLandingProps) => {
  const isS = useMediaQuery(small);
  const isL = useMediaQuery(large);

  return (
    <>
      <div className={styles['partners-bar']}>
        <div className={styles['title']}>Trusted by</div>
        <HorizontalScroll paddingTop={isS ? '32px' : isL ? '44px' : '67px'} paddingLeft="0px" paddingRight="0px">
          {logos.map(logo => (
            <div className={styles['partners-bar-item']} key={logo}>
              <div className={styles['partners-bar-image']}>
                <img
                  src={logo}
                  placeholder="blur"
                  blurDataURL="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
                  layout="fill"
                  objectFit="contain"
                  priority
                width="100%"/>
              </div>
            </div>
          ))}
          <div className={styles['text']}>& more</div>
        </HorizontalScroll>
      </div>
    </>
  );
};

export default PartnerBarLanding;
