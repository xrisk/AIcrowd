import React from 'react';
import isDarkColor from 'is-dark-color';
import Image from 'next/image';

import AvatarGroup from 'src/components/molecules/AvatarGroup';
import CircleValue from 'src/components/atoms/CircleValue';
import CardBadge from 'src/components/atoms/CardBadge';

import styles from './landingChallengeCard.module.scss';
const {
  main,
  titleText,
  prizeText,
  participantsWrapper,
  circleValue,
  challengeImage,
  cardBottomWrapper,
  cardFooter,
  container,
  cardBadgeWrapper,
  organizerName,
  organizerLogo,
  organizerWrapper,
} = styles;

import { Users } from 'src/types';

export type LandingChallengeCardProps = {
  slug: string;
  image: string;
  name: string;
  prize: [string];
  users: [Users];
  userCount: number;
  color: string;
  loading: boolean;
  badgeColor: string;
  challengeEndDate: string;
  cardBadge: boolean;
  organizers: [{ name: string; logo: string; link: string }];
  isOngoing: boolean;
};

const LandingChallengeCard = ({
  slug,
  image,
  name,
  prize,
  users,
  userCount,
  color,
  loading,
  badgeColor,
  challengeEndDate,
  cardBadge,
  organizers,
  isOngoing,
}: LandingChallengeCardProps) => {
  const isWhite = color === '#FFFFFF';

  // Detects the dark color
  const isDark = isDarkColor(color);
  const invertedColor = isDark ? '#ffffff' : '#1f1f1f';

  return (
    <>
      <a href= {`/challenges/${slug}`}>
      <div className={container}>
        <div className={main} style={{ background: color }}>
        { isOngoing &&
          (<div className={cardBadgeWrapper}>
            <CardBadge badgeColor={badgeColor} challengeEndDate={challengeEndDate} cardBadge={cardBadge} />
          </div>)
        }
          <img src={image} className={challengeImage}></img>
          <div className={cardBottomWrapper}>
            <div className={titleText} style={{ color: invertedColor }}>
              {name}
            </div>
            <div className={prizeText} style={{ color: isWhite ? '#747474' : invertedColor }}>
              {/* {prize} */}
              {prize.map((priz, i) => {
                return (
                  <span key={i} style={{ color: isWhite ? '#747474' : invertedColor }}>
                    {priz} {i + 1 < prize.length && '•'}&nbsp;
                  </span>
                );
              })}
            </div>
          </div>

          <div className={participantsWrapper}>
            <AvatarGroup users={users} size="sm" onCard={true} borderColor={color} loading={loading} />
            <div className={circleValue}>
              <a>{userCount}</a>
              <CircleValue value={userCount} size="sm" onCard={true} borderColor={color} />
            </div>
          </div>
        </div>
        <div className={cardFooter}>
          {organizers.map(organizer => {
            const name = organizer.name
            const logo = organizer.logo
            const link = organizer.link
            return (
              <a href={link} key={name}>
                <div className={organizerWrapper}>
                  <img src={logo} className={organizerLogo}></img>
                  {/* Hide names if organizers are more then 1 */}
                  {organizers?.length < 2 ? <div className={organizerName}>{name}</div> : <></>}
                </div>
              </a>
            );
          })}
        </div>
      </div>
      </a>
    </>
  );
};

export default LandingChallengeCard;
