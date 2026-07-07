package datt.nguyenthanhlong.laptopshop.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.intercept.AuthorizationFilter;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.http.HttpStatus;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;

import jakarta.servlet.DispatcherType;
import datt.nguyenthanhlong.laptopshop.service.CustomUserDetailsService;
import datt.nguyenthanhlong.laptopshop.service.UserService;

@Configuration
@EnableMethodSecurity(securedEnabled = true)
public class SecurityConfigurtation {
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    @Bean
    public UserDetailsService userDetailsService(UserService userService) {
        return new CustomUserDetailsService(userService);
    }
    // Lỗi vòng lặp không giới hạn khi login sai password
    // @Bean
    // public AuthenticationManager authenticationManager(HttpSecurity http, PasswordEncoder passwordEncoder,
    // UserDetailsService userDetailsService) throws Exception {
    //     AuthenticationManagerBuilder authenticationManagerBuilder = http
    //         .getSharedObject(AuthenticationManagerBuilder.class);
    //     authenticationManagerBuilder
    //         .userDetailsService(userDetailsService)
    //         .passwordEncoder(passwordEncoder);
    //     return authenticationManagerBuilder.build();
    // }
    @Bean
    public DaoAuthenticationProvider authProvider(
        PasswordEncoder passwordEncoder,
        UserDetailsService userDetailsService) {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder);
        // authProvider.setHideUserNotFoundExceptions(false);
        return authProvider;
    }
    // Cấu hình cho firewall để cho phép chuỗi "//" trong URL
    @Bean
    public HttpFirewall allowUrlEncodedSlashHttpFirewall() {
        StrictHttpFirewall firewall = new StrictHttpFirewall();
        firewall.setAllowUrlEncodedDoubleSlash(true);  // Cho phép chuỗi "//" trong URL
        return firewall;
    }

    @Bean
    SecurityFilterChain filterChain(HttpSecurity http,
            TabAuthenticationFilter tabAuthenticationFilter,
            TabTokenRedirectFilter tabTokenRedirectFilter) throws Exception {
        http
            .csrf(csrf -> csrf.csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse()))
            .authorizeHttpRequests(authorize -> authorize
                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE) .permitAll()
                .requestMatchers("/", "/login", "/register", "/tab-login", "/tab-logout", "/laptop-finder", "/ai-chat", "/ai-chat/api", "/ai-chat/api/**", "/ws/ai-chat", "/product/**", "/client/**", "/css/**", "/js/**", "/images/**", "/avatar/**", "/lib/**").permitAll()
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated())
            .sessionManagement((sessionManagement) -> sessionManagement.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .securityContext(securityContext -> securityContext.requireExplicitSave(false))
            .requestCache(requestCache -> requestCache.disable())
            .formLogin(formLogin -> formLogin.disable())
            .logout(logout -> logout.disable())
            .rememberMe(rememberMe -> rememberMe.disable())
            .httpBasic(Customizer.withDefaults())
            .exceptionHandling(exceptionHandling -> exceptionHandling
                    .authenticationEntryPoint((request, response, authException) -> response.sendRedirect("/login"))
                    .accessDeniedPage("/403"))
            .addFilterBefore(tabAuthenticationFilter, AuthorizationFilter.class)
            .addFilterAfter(tabTokenRedirectFilter, TabAuthenticationFilter.class);

        return http.build();
    }

}
