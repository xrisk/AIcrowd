import React from 'react';

import useMediaQuery from 'src/hooks/useMediaQuery';
import { sizes } from 'src/constants/screenSizes';

import ButtonDefault from 'src/components/atoms/Button/ButtonDefault';
import AicrowdLogo from 'src/components/atoms/AicrowdLogo';

import styles from './landingChallengeCard.module.scss';
import ActionButton from 'src/components/atoms/Button/ActionButton';
const { main, titleText, descriptionText, heroTitle, buttonWrapper, registerButtonWrapper } = styles;

export type LandingHeaderContentProps = {
  url?: string
  title?: string;
  description: any;
  buttonText: string;
  hero?: boolean;
  descriptionWidth?: string;
  logo?: boolean;
  buttonType?: string;
  isLoggedIn?: boolean;
};

const LandingHeaderContent = ({
  url,
  title,
  description,
  buttonText,
  hero,
  descriptionWidth,
  logo,
  buttonType,
  isLoggedIn,
}: LandingHeaderContentProps) => {
  const { wide, xLarge, xSmall, small, medium, large, smallMedium } = sizes;

  const isS = useMediaQuery(small);
  const isXL = useMediaQuery(xLarge);
  const isXS = useMediaQuery(xSmall);
  const isL = useMediaQuery(large);

  const isJoinCommunity = title === 'Join our Global Community';
  const isWelcomeAicrowd = title === 'Welcome to AIcrowd Community'
  return (
    <>
      <div className={main}>
        {hero && !isXS && (
          <div className={heroTitle}>
            Crowdsourcing AI <br />
            to Solve Real-World Problems
          </div>
        )}
        {/* Show only on small screen */}
        {hero && isXS && (
          <div className={heroTitle}>
            Crowdsourcing AI to <br />
            Solve Real-World Problems
          </div>
        )}
        {!hero && (
          <div>
            {logo && (
              <AicrowdLogo
                type="text"
                size={isS ? 28 : isL ? 34 : isXL ? 40 : 48}
                fontFamily="Inter"
                fontWeight={isL ? 500 : 600}
              />
            )}{' '}
            <span className={titleText} style={{ width: descriptionWidth }}>
              {title}
            </span>
          </div>
        )}
        <div className={descriptionText} style={{ width: descriptionWidth }}>
          {hero && <AicrowdLogo type="text" size={isXL ? 16 : 19} fontFamily="Inter" />} {description}
        </div>
        <div className={buttonWrapper}>
          {/* Show in hero only */}
          {hero && (
            <div style={{ paddingRight: '26px' }}>
              <a href="/challenges">
              <ButtonDefault
                text="Our Challenges"
                iconClass="arrow-right"
                iconColor="white"
                type="primary"
                paddingTop="8px"
                paddingBottom="8px"
                iconSize="18px"
                fontFamily="Inter"
                handleClick={() => {}}
              />
              </a>
            </div>
          )}
          {/* Hide button for hero in small screen */}
          {(hero && isS) || isJoinCommunity || isWelcomeAicrowd ? (
            <></>
          ) : (
            <a href={url}>
            <ButtonDefault
              text={buttonText}
              iconClass="arrow-right"
              iconColor={buttonType === 'primary' ? '#ffffff' : '#F0524D'}
              type={buttonType || 'secondary'}
              paddingTop="8px"
              paddingBottom="8px"
              iconSize="18px"
              fontFamily="Inter"
              handleClick={() => {}}
            />
            </a>
          )}
        </div>
        {/* Show only on join our community section */}
        {isJoinCommunity && (
          <div className={registerButtonWrapper}>
            {!isLoggedIn && (
              <>
                <a href="/participants/auth/google_oauth2" style={{marginBottom: '16px'}}>
                  <ActionButton type="google" size="large" fontFamily="Inter" />
                </a>
                <a href="/participants/auth/github" style={{marginBottom: "16px"}}>
                  <ActionButton type="github" size="large" fontFamily="Inter" />
                </a>

                <ButtonDefault
                  text="Sign Up With Email"
                  iconClass="envelope"
                  iconColor="#F0524D"
                  type="secondary"
                  iconSize="24px"
                  size="large"
                  iconLeft
                  fontSize="12px"
                  fontWeight="500"
                  fontFamily="Inter"
                  justifyContent="flex-end"
                />
              </>
            )}
            {isLoggedIn && (
              <>
                <ButtonDefault
                  text="Explore Challenges"
                  iconClass="arrow-right"
                  iconColor="#F0524D"
                  type="secondary"
                  iconSize="24px"
                  size="large"
                  fontSize="12px"
                  fontWeight="500"
                  fontFamily="Inter"
                  justifyContent="flex-end"
                />
                <ButtonDefault
                  text="Explore Notebooks"
                  iconClass="arrow-right"
                  iconColor="#F0524D"
                  type="secondary"
                  iconSize="24px"
                  size="large"
                  fontSize="12px"
                  fontWeight="500"
                  fontFamily="Inter"
                  justifyContent="flex-end"
                />
                <ButtonDefault
                  text="Explore Discussions"
                  iconClass="arrow-right"
                  iconColor="#F0524D"
                  type="secondary"
                  iconSize="24px"
                  size="large"
                  fontSize="12px"
                  fontWeight="500"
                  fontFamily="Inter"
                  justifyContent="flex-end"
                />
              </>
            )}
          </div>
        )}
      </div>
    </>
  );
};

export default LandingHeaderContent;
