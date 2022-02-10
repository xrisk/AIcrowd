import React from 'react';
import { useRouter } from 'next/router';
import Link from 'next/link';

import LogoMark from 'src/components/atoms/LogoMark';
import styles from './siteFooter.module.scss';
import ScrollToTop from './ScrollToTop/index';

const SiteFooter = ({ removeMargin }) => {
  const router = useRouter();

  const platformLinks = [
    { name: 'Challenges', link: '/challenges' },
    { name: 'Practice', link: '/challenges' },
    { name: 'Organize a Challenge', link: '/landing_page/host' },
    { name: 'FAQ', link: '/faq' },
    { name: 'Our Team', link: '/our_team' },
    { name: 'Jobs', link: '/jobs' },
  ];

  const connectLinks = [
    { name: 'Blog', link: '/blogs', icon: false },
    { name: 'Contact', link: '/contact', icon: false },
    { name: 'Discourse', link: '//discourse.aicrowd.com', icon: true },
    { name: 'Github', link: '//github.com/aicrowd/', icon: true },
    { name: 'GitLab', link: '//gitlab.aicrowd.com', icon: true },
    { name: 'Twitter', link: '//twitter.com/AIcrowdHQ', icon: true },
  ];

  const legalLinks = [
    { name: 'Cookie consent', link: '/cookies' },
    { name: 'Participation Terms', link: 'participation_terms' },
    { name: 'Privacy Policy', link: '/privacy' },
    { name: 'Terms of Use', link: '/terms' },
    { name: 'AI & Ethics', link: '/ai_ethics' },
  ];

  const languages = [
    { name: 'English', languageKey: 'en' },
    { name: 'French', languageKey: 'fr' },
    { name: 'Spanish', languageKey: 'es' },
    { name: 'Russian', languageKey: 'ru' },
  ];

  return (
    <>
      <footer className={styles['site-footer']} role="contentinfo" style={{ marginTop: removeMargin && '0px' }}>
        <div className={styles['container-center']}>
          <div className={styles['site-footer-content']}>
            <div className={styles['site-footer-brand']}>
              <LogoMark link="/" />
            </div>

            <div className={styles['site-footer-platform']}>
              <h4 className={styles['site-footer-title']}>Platform</h4>

              <ul className={styles['site-footer-nav']} role="navigation">
                {/* Show links under "Platform" */}
                {platformLinks.map(item => {
                  const { name, link } = item;
                  return (
                    <li className={styles['site-footer-nav-item']} key={name}>
                      <a className={styles['site-footer-nav-link']} href={link}>
                        {name}
                      </a>
                    </li>
                  );
                })}
              </ul>
            </div>

            <div className={styles['site-footer-connect']}>
              <h4 className={styles['site-footer-title']}>Connect</h4>

              <ul className={styles['site-footer-nav']} role="navigation">
                {/* Show links under "Connect" */}
                {connectLinks.map(item => {
                  const { name, link, icon } = item;
                  return (
                    <li className={styles['site-footer-nav-item']} key={name}>
                      <a className={styles['site-footer-nav-link']} href={link}>
                        {name}
                        {icon && <i className="las la-external-link-alt"></i>}
                      </a>
                    </li>
                  );
                })}
              </ul>
            </div>

            <div className={styles['site-footer-legal']}>
              <h4 className={styles['site-footer-title']}>Legal</h4>

              <ul className={styles['site-footer-nav']} role="navigation">
                {/* Show links under "Legal" */}
                {legalLinks.map(item => {
                  const { name, link } = item;
                  return (
                    <li className={styles['site-footer-nav-item']} key={name}>
                      <a className={styles['site-footer-nav-link']} href={link}>
                        {name}
                      </a>
                    </li>
                  );
                })}
              </ul>
              <span className={styles['site-footer-text']}>&copy; 2021 AIcrowd. All Rights Reserved.</span>
            </div>
            {/* Language change */}
            <div className={styles['site-footer-language']}>
              {/* ----------- uncomment to show languages change list ------------ */}
              {/* <h4 className={styles['site-footer-title']}>Languages</h4> */}

              <ul className={styles['site-footer-nav']} role="navigation">
                {/* Show links under "Languages" */}
                {/* {languages.map(item => {
                  const { name, languageKey } = item;
                  return (
                    <li className={styles['site-footer-nav-item']} key={name}>
                      <Link href={`${router.asPath}`} locale={languageKey}>
                        <a className={styles['site-footer-nav-link']}>{name}</a>
                      </Link>
                    </li>
                  );
                })} */}
              </ul>
            </div>

            <div className={styles['site-footer-end']}>
              <ScrollToTop />
            </div>
          </div>
        </div>
      </footer>
    </>
  );
};
export default SiteFooter;
