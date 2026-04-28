import { createRouter, createWebHistory } from 'vue-router'
import DashboardView from '../views/DashboardView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'dashboard',
      component: DashboardView
    },
    {
      path: '/leagues',
      name: 'leagues',
      component: () => import('../views/LeaguesView.vue')
    },
    {
      path: '/tournaments',
      name: 'tournaments',
      component: () => import('../views/TournamentsView.vue')
    },
    {
      path: '/matches',
      name: 'matches',
      component: () => import('../views/MatchesView.vue')
    },
    {
      path: '/analytics',
      name: 'analytics',
      component: () => import('../views/AnalyticsView.vue')
    }
  ]
})

export default router
