import React, { useState, useEffect } from 'react';
import cx from 'classnames';
import { useRouter } from 'next/router';

import { Link as ScrollLink } from 'react-scroll';

import styles from './mastHeadLanding.module.scss';
import useMediaQuery from 'src/hooks/useMediaQuery';
import { sizes } from 'src/constants/screenSizes';
import LandingHeaderContent from '../LandingHeaderContent';
import LandingStatList from '../LandingStatList';
import { LandingStatItemProps } from 'src/components/molecules/LandingStatItem';
import LandingChallengeCard, { LandingChallengeCardProps } from 'src/components/organisms/LandingChallengeCard';
const { main, glowDecor, cardWrapper, statListContainer } = styles;

export type MastHeadLandingProps = {
  statListData: [LandingStatItemProps];
  landingChallengeCard1: LandingChallengeCardProps;
  landingChallengeCard2: LandingChallengeCardProps;
  landingChallengeCard3: LandingChallengeCardProps;
  loading: boolean;
};

const MastHeadLanding = ({
  statListData,
  landingChallengeCard1,
  landingChallengeCard2,
  landingChallengeCard3,
  loading,
}: MastHeadLandingProps) => {
  const router = useRouter();
  const isS = useMediaQuery(sizes.small);
  const isXS = useMediaQuery(sizes.xSmall);
  const isM = useMediaQuery(sizes.medium);
  const isL = useMediaQuery(sizes.large);

  const description = `enables data science experts and enthusiasts 
  to collaboratively solve real-world problems, through challenges.`;

  return (
    <>
      <div className={main}>
        <div style={{ position: 'relative' }}>
          <LandingHeaderContent
            hero
            description={description}
            buttonText="Host a Challenge"
            url="/landing_page/host"
            descriptionWidth={isXS ? '288px' : isS ? '368px' : isL ? '581px' : '624px'}
          />
          <div className={statListContainer}>
            <LandingStatList statListData={statListData} />
          </div>
        </div>
        <div className={cardWrapper}>
          <div className={glowDecor}></div>
          {!isM && (
            <>
              <div data-card="card1">
                <LandingChallengeCard loading={loading} {...landingChallengeCard2} priority />
              </div>

              <div data-card="card2">
                <LandingChallengeCard loading={loading} {...landingChallengeCard1} priority />
              </div>
              <div data-card="card3">
                <LandingChallengeCard loading={loading} {...landingChallengeCard3} priority />
              </div>
            </>
          )}
        </div>
      </div>
    </>
  );
};

export default MastHeadLanding;
