import React from 'react';
import Image from 'next/image';

import HorizontalScroll from 'src/components/utility/HorizontalScroll';
import styles from './partnerBarLanding.module.scss';
import useMediaQuery from 'src/hooks/useMediaQuery';
import { sizes } from 'src/constants/screenSizes';

const { wide, xLarge, xSmall, small, medium, large, smallMedium } = sizes;

export type PartnerBarLandingProps = {
  logos: [string];
  color?: string;
};

const PartnerBarLanding = ({ logos, color }: PartnerBarLandingProps) => {
  const isXS = useMediaQuery(xSmall);
  const isS = useMediaQuery(small);
  const isL = useMediaQuery(large);

  return (
    <>
      <div className={styles['partners-bar']}>
        <div className={styles['title']}>Trusted By</div>
        <HorizontalScroll paddingTop={isS ? '32px' : isL ? '44px' : '67px'} paddingLeft="0px" paddingRight="0px">
          {logos.map(logo => (
            <div className={styles['partners-bar-item']} key={logo}>
              <div className={styles['partners-bar-image']}>
                <Image
                  src={logo}
                  placeholder="blur"
                  blurDataURL="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
                  layout="fill"
                  objectFit="contain"
                  priority
                />
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
