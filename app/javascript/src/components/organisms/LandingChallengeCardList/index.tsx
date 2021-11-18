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
        const { image, name, prize, users, color, badgeColor, challengeEndDate, cardBadge, organizers } = item;
        return (
          <div className={cardWrapper} key={i}>
            <LandingChallengeCard
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
            />
          </div>
        );
      })}
    </div>
  </>
);

export default LandingChallengeCardList;