/*
 * Copyright (C) 2021 Intel Corporation
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <stdio.h>
#include <reent.h>
#include <limits.h>
#include "includes.h"

#define NO_TIMEOUT 0

/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK    task1_stk[TASK_STACKSIZE];
OS_STK    task2_stk[TASK_STACKSIZE];
OS_STK    task3_stk[TASK_STACKSIZE];
OS_EVENT  *g_mutex;

/* Definition of priorities */
#define MUTEX_PRIORITY      1
#define TASK1_PRIORITY      2
#define TASK2_PRIORITY      3
#define TASK3_PRIORITY      4

#define NUM_PRINTS_PER_TASK 100

void task1(void* pdata)
{
	INT8U err;
	int i = 0;
	int ms_slept = *((int *)pdata);
	while (1)
	{
		OSMutexPend(g_mutex, NO_TIMEOUT, &err);
		if (i < NUM_PRINTS_PER_TASK) {
			printf("Hello from task1: %d\n\n", i++);
		}
		OSMutexPost(g_mutex);
		OSTimeDlyHMSM(0, 0, 0, ms_slept);
	}
}

void task2(void* pdata)
{
	INT8U err;
	int i = 0;
	int ms_slept = *((int *)pdata);
	while (1)
	{
		OSMutexPend(g_mutex, NO_TIMEOUT, &err);
		if (i < NUM_PRINTS_PER_TASK) {
			printf("Hello from task2: %d\n\n", i++);
		}
		OSMutexPost(g_mutex);
		OSTimeDlyHMSM(0, 0, 0, ms_slept);
	}
}

void task3(void* pdata)
{
	INT8U err;
	int i = 0;
	int ms_slept = *((int *)pdata);
	while (1)
	{
		OSMutexPend(g_mutex, NO_TIMEOUT, &err);
		if (i < NUM_PRINTS_PER_TASK) {
			printf("Hello from task3: %d\n\n", i++);
		}
		OSMutexPost(g_mutex);
		OSTimeDlyHMSM(0, 0, 0, ms_slept);
	}
}

/* The main function creates tasks and starts multi-tasking */
int main(void)
{
	printf("Hello from main...\n");
	printf("Task1 -- TOS: %p, BOS: %p\n", &task1_stk[TASK_STACKSIZE-1], &task1_stk[0]);
	printf("Task2 -- TOS: %p, BOS: %p\n", &task2_stk[TASK_STACKSIZE-1], &task2_stk[0]);
	printf("Task3 -- TOS: %p, BOS: %p\n", &task3_stk[TASK_STACKSIZE-1], &task3_stk[0]);
	printf("Stat -- TOS: %p, BOS: %p\n", &OSTaskStatStk[OS_TASK_STAT_STK_SIZE - 1u], &OSTaskStatStk[0]);
	printf("Idle -- TOS: %p, BOS: %p\n", &OSTaskIdleStk[OS_TASK_IDLE_STK_SIZE - 1u], &OSTaskIdleStk[0]);

	INT8U err;
	g_mutex = OSMutexCreate(MUTEX_PRIORITY, &err);

	int t1_ms_slept = 750;
	int t2_ms_slept = 450;
	int t3_ms_slept = 250;
	OSTaskCreateExt(task1,
			&t1_ms_slept,
			(void *)&task1_stk[TASK_STACKSIZE-1],
			TASK1_PRIORITY,
			TASK1_PRIORITY,
			task1_stk,
			TASK_STACKSIZE,
			NULL,
			0);     
	OSTaskCreateExt(task2,
			&t2_ms_slept,
			(void *)&task2_stk[TASK_STACKSIZE-1],
			TASK2_PRIORITY,
			TASK2_PRIORITY,
			task2_stk,
			TASK_STACKSIZE,
			NULL,
			0);
	OSTaskCreateExt(task3,
			&t3_ms_slept,
			(void *)&task3_stk[TASK_STACKSIZE-1],
			TASK3_PRIORITY,
			TASK3_PRIORITY,
			task3_stk,
			TASK_STACKSIZE,
			NULL,
			0);
            
	OSStart();
	return 0;
}
