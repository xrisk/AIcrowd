import React from 'react';

import styles from './landingChallengeCardList.module.scss';
import LandingChallengeCard, { LandingChallengeCardProps } from '../LandingChallengeCard/index';
const { main, cardWrapper } = styles;

export type LandingChallengeCardListProps = {
  challengeListData: [LandingChallengeCardProps];
  loading: boolean;
};

const LandingChallengeCardList = ({ challengeListData, loading }: LandingChallengeCardListProps) => (
  <>
    <div className={main}>
      {challengeListData.map((item, i) => {
        const { slug, image, name, prize, users, color, badgeColor, challengeEndDate, cardBadge, organizers, isOngoing } = item;
        return (
          <div className={cardWrapper} key={i}>
            <div data-challenge={i + 1}>
              <LandingChallengeCard
                slug={slug}
                image={image}
                name={name}
                prize={prize}
                users={users}
                color={color}
                loading={loading}
                badgeColor={badgeColor}
                challengeEndDate={challengeEndDate}
                cardBadge={cardBadge}
                organizers={organizers}
                isOngoing={isOngoing}
              />
            </div>
          </div>
        );
      })}
    </div>
  </>
);

export default LandingChallengeCardList;
