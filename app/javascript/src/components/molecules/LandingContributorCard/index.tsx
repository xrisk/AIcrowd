import React from 'react';

import AvatarWithTier from 'src/components/atoms/AvatarWithTier';
import styles from './landingContributor.module.scss';

const { mainWrapper, titleText, countText, subWrapper } = styles;

export type LandingContributorCardProps = {
  username: string;
  count: number;
  tier: number;
  image: string;
  loading: boolean;
  onCard?: boolean;
  borderColor: string;
};

const LandingContributorCard = ({
  username,
  count,
  tier,
  image,
  loading,
  onCard,
  borderColor,
}: LandingContributorCardProps) => {
  return (
    <>
      <div className={mainWrapper}>
        <div className={subWrapper}>
          <AvatarWithTier
            tier={tier}
            image={image}
            loading={loading}
            size="sm"
            onCard={onCard}
            borderColor={borderColor}
          />
          <div className={titleText}>{username}</div>
        </div>
        <div className={countText}>{count}</div>
      </div>
    </>
  );
};

export default LandingContributorCard;
