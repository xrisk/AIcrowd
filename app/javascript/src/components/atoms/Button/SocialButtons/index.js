import React from 'react';
import { FacebookFIcon, TwitterIcon, LinkedinIcon } from 'react-line-awesome';
import PropTypes from 'prop-types';

import styles from './socialButtons.module.scss';

const SocialButtons = ({ socialType, link, iconType }) => {
  const gradientTwitter = 'https://images.aicrowd.com/images/landing_page/twitter-gradient.svg';
  // Capitalize first letter of social name passed
  const firstLetterCapital = socialType.charAt(0).toUpperCase();
  const excludeFirstLetter = socialType.slice(1);
  const capitalizeSocialName = firstLetterCapital + excludeFirstLetter;
  const label = `Share on ${capitalizeSocialName}`;

  const discord = `https://images.aicrowd.com/images/landing_page/discord.svg`;
  const twitter = `https://images.aicrowd.com/images/landing_page/twitter.svg`;
  const facebook = `https://images.aicrowd.com/images/landing_page/facebook.svg`;
  const youtube = `https://images.aicrowd.com/images/landing_page/youtube.svg`;
  const linkedin = `https://images.aicrowd.com/images/landing_page/linkedin.svg`;

  if (iconType === 'outline') {
    return (
      <a href={link} target="_blank" rel="noreferrer">
        {socialType === 'facebook' && <img src={facebook} alt="facebook icon" />}
        {socialType === 'twitter' && <img src={twitter} alt="twitter icon" />}
        {socialType === 'linkedin' && <img src={linkedin} alt="linkedin icon" />}
        {socialType === 'youtube' && <img src={youtube} alt="youtube icon" />}
        {socialType === 'discord' && <img src={discord} alt="discord icon" />}
      </a>
    );
  }

  return (
    <>
      <a
        className={styles[`btn-${socialType}`]}
        aria-label={label}
        data-balloon-pos="up"
        href={link}
        role="button"
        target="_blank"
        rel="noreferrer">
        {socialType === 'twitter' && <TwitterIcon className={styles['lab']} />}
        {socialType === 'facebook' && <FacebookFIcon className={styles['lab']} />}
        {socialType === 'linkedin' && <LinkedinIcon className={styles['lab']} />}
        <span className={styles['sr-only']}>{label}</span>
      </a>
    </>
  );
};

SocialButtons.propTypes = {
  socialType: PropTypes.string.isRequired,
  link: PropTypes.string.isRequired,
  iconType: PropTypes.string,
};

export default SocialButtons;
