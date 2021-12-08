import React from 'react';
import isDarkColor from 'is-dark-color';
import Image from 'next/image';
import Link from 'src/components/atoms/Link';

import AvatarGroup from 'src/components/molecules/AvatarGroup';
import CircleValue from 'src/components/atoms/CircleValue';
import CardBadge from 'src/components/atoms/CardBadge';
import useMediaQuery from 'src/hooks/useMediaQuery';
import { sizes } from 'src/constants/screenSizes';

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
  logoWrapper,
} = styles;

import { Users } from 'src/types';
import Tooltip from 'src/components/atoms/Tooltip';

export type LandingChallengeCardProps = {
  image: string;
  name: string;
  prize: [string];
  users: [Users];
  color: string;
  loading: boolean;
  badgeColor: string;
  challengeEndDate: string;
  cardBadge: boolean;
  organizers: [{ name: string; logo: string; link: string }];
  userCount: number;
  url: string;
  priority?: boolean;
};

const LandingChallengeCard = ({
  image,
  name,
  prize,
  users,
  color,
  loading,
  badgeColor,
  challengeEndDate,
  cardBadge,
  organizers,
  userCount,
  url,
  priority,
}: LandingChallengeCardProps) => {
  const { wide, xLarge, xSmall, small, medium, large, smallMedium } = sizes;
  const isS = useMediaQuery(small);
  const isWhite = color === '#FFFFFF';

  // Detects the dark color
  const isDark = isDarkColor(color);
  const invertedColor = isDark ? '#ffffff' : '#1f1f1f';

  return (
    <>
      <div className={container}>
        <a href={url}>
          <a>
            <div className={main} style={{ background: color }}>
              <div className={cardBadgeWrapper}>
                <CardBadge badgeColor={badgeColor} challengeEndDate={challengeEndDate} cardBadge={cardBadge} />
              </div>
              <img
                src={image}
                placeholder="blur"
                blurDataURL="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
                width={isS ? 112 : 180}
                height={isS ? 112 : 180}
                className={challengeImage}
                priority={priority}
              />
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
                <AvatarGroup
                  users={users}
                  size="sm"
                  onCard={true}
                  borderColor={color}
                  loading={loading}
                  priority={priority}
                />
                <div className={circleValue}>
                  <CircleValue value={userCount} size="sm" onCard={true} borderColor={color} />
                </div>
              </div>
            </div>
          </a>
        </a>
        <div className={cardFooter}>
          {organizers.map(organizer => {
            const { name, logo, link } = organizer;
            return (
              <a href={link} key={name}>
                <div className={organizerWrapper}>
                  <Tooltip position="down" label={name}>
                    <div className={logoWrapper}>
                      <img
                        src={logo}
                        placeholder="blur"
                        blurDataURL="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
                        layout="fill"
                        objectFit="contain"
                        priority={priority}
                      />
                    </div>
                  </Tooltip>
                  {/* Hide names if organizers are more then 1 */}
                  {organizers?.length < 2 ? (
                    <Tooltip position="down" label={name}>
                      <div className={organizerName}>{name}</div>{' '}
                    </Tooltip>
                  ) : (
                    <></>
                  )}
                </div>
              </a>
            );
          })}
        </div>
      </div>
    </>
  );
};

export default LandingChallengeCard;
