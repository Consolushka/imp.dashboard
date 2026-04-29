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
      path: '/ideology',
      name: 'ideology',
      component: () => import('../views/IdeologyView.vue')
    },
    {
      path: '/statistics',
      name: 'statistics',
      redirect: to => {
        return { name: 'match-statistics', params: { id: 1 } }
      }
    },
    {
      path: '/matches/:id/statistics',
      name: 'match-statistics',
      component: () => import('../views/MatchStatisticsView.vue')
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'not-found',
      component: () => import('../views/NotFoundView.vue')
    }
  ]
})

export default router
