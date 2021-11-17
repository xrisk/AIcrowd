import React from 'react';
import { useRouter } from 'next/router';
import Link from 'next/link';

import LogoMark from 'src/components/atoms/LogoMark';
import styles from './siteFooter.module.scss';
import ScrollToTop from './ScrollToTop/index';

const SiteFooter = ({ removeMargin }) => {
  const router = useRouter();

  const platformLinks = [
    { name: 'Challenges', link: '' },
    { name: 'Practice', link: '' },
    { name: 'Organize a Challenge', link: '' },
    { name: 'User Rankings', link: '' },
    { name: 'FAQ', link: '' },
    { name: 'Our Team', link: '' },
    { name: 'Jobs', link: '' },
  ];

  const connectLinks = [
    { name: 'Blog', link: '', icon: false },
    { name: 'Contact', link: '', icon: false },
    { name: 'Discourse', link: '', icon: true },
    { name: 'Github', link: '', icon: true },
    { name: 'GitLab', link: '', icon: true },
    { name: 'Twitter', link: '', icon: true },
  ];

  const legalLinks = [
    { name: 'Cookie consent', link: '' },
    { name: 'Participation Terms', link: '' },
    { name: 'Privacy Policy', link: '' },
    { name: 'Terms of Use', link: '' },
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
              <span className={styles['site-footer-text']}>&copy; 2020 AIcrowd. All Rights Reserved.</span>
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
