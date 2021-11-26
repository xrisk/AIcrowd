import React, { useState, useEffect } from 'react';
import cx from 'classnames';

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
  const isS = useMediaQuery(sizes.small);
  const isXL = useMediaQuery(sizes.xLarge);
  const isXS = useMediaQuery(sizes.xSmall);
  const isM = useMediaQuery(sizes.medium);

  const description = `enables data science experts and enthusiasts
  to collaboratively solve real-world problems, through challenges `;

  return (
    <>
      <div className={main}>
        <div style={{ position: 'relative' }}>
          <LandingHeaderContent
            hero
            url="/landing_page/host"
            description={description}
            buttonText="Host a Challenge"
            descriptionWidth={isXS ? '288px' : isS ? '368px' : isM ? '500px' : '624px'}
          />
          <div className={statListContainer}>
            <LandingStatList statListData={statListData} />
          </div>
          <div className={glowDecor}></div>
        </div>
        {!isM && (
          <div className={cardWrapper}>
            <div data-card="card1">
              <LandingChallengeCard loading={loading} {...landingChallengeCard2} />
            </div>

            <div data-card="card2">
              <LandingChallengeCard loading={loading} {...landingChallengeCard1} />
            </div>
            <div data-card="card3">
              <LandingChallengeCard loading={loading} {...landingChallengeCard3} />
            </div>
          </div>
        )}
      </div>
    </>
  );
};

export default MastHeadLanding;
